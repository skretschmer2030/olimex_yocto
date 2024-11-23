# Configure recipe for CubeMX
inherit cubemx-stm32mp

python () {
    soc_package = (d.getVar('CUBEMX_SOC_PACKAGE') or "").split()
    if len(soc_package) > 1:
        bb.fatal('The CUBEMX_SOC_PACKAGE is initialized to: %s ! This var should only contains ONE package version' % soc_package)

    ddr_size = d.getVar('CUBEMX_BOARD_DDR_SIZE')
    if ddr_size is not None:
        size = int(ddr_size) * 1024 * 1024
        d.setVar('CUBEMX_BOARD_DDR_SIZE_HEXA', "0x%x" % size)
    else:
        d.setVar('CUBEMX_BOARD_DDR_SIZE_HEXA', "")
}

# manage paramater value
# PACKAGE OF SOC
CUBEMX_SOC_PACKAGE_option = "\
    ${@bb.utils.contains_any('CUBEMX_SOC_PACKAGE', [ 'A', 'D' ], 'CFG_STM32_CRYP=n', '', d)} \
    ${@bb.utils.contains_any('CUBEMX_SOC_PACKAGE', [ 'C', 'F' ], 'CFG_STM32_CRYP=n', '', d)} \
    "
# Memory size
CUBEMX_BOARD_DDR_SIZE_option = "\
    ${@'CFG_DRAM_SIZE=${CUBEMX_BOARD_DDR_SIZE_HEXA}' if (d.getVar('CUBEMX_BOARD_DDR_SIZE_HEXA') != '') else '' } \
    "
# DVFS OFF
CUBEMX_SOC_DVFS_OFF_option = "\
    ${@bb.utils.contains('CUBEMX_SOC_DVFS_OFF', '1', 'CFG_STM32MP1_CPU_OPP=n FG_SCMI_MSG_PERF_DOMAIN=n', '', d)} \
    "

EXTRA_OEMAKE += "${CUBEMX_SOC_PACKAGE_option} ${CUBEMX_BOARD_DDR_SIZE_option} ${CUBEMX_SOC_DVFS_OFF_option}"

EXTRA_OEMAKE += "CFG_STM32MP_PROVISIONING=n"

# for generating external dt Makefile
SOC_OPTEE_CONFIG_SUPPORTED = "MP13 MP15 MP25"

ST_OPTEE_EXPORT_TA_REF_BOARD:stm32mpcommonmx = "${CUBEMX_DTB}.dts"
ST_OPTEE_EXPORT_TA_OEMAKE_EXTRA = ""
# ------------------------------------------------
# Generate optee conf for usage of EXTERNAL DT with cubemx devicetree
# ------------------------------------------------
autogenerate_conf_for_external_dt_cubemx() {
    [ "${ENABLE_CUBEMX_DTB}" -ne 1 ] && return;
    if [ -e "${STAGING_EXTDT_DIR}/${EXTDT_DIR_OPTEE}/conf.mk" ]; then
        [ "${CUBEMX_EXTDT_FORCE_MK}" -ne 1 ] && return
    fi
    echo "# SPDX-License-Identifier: BSD-2-Clause" > ${WORKDIR}/conf.external_dt
    echo "" >>  ${WORKDIR}/conf.external_dt

    dtb=$(echo ${STM32MP_DEVICETREE} | tr ' ' '\n' | uniq | tr '\n' ' ')
    for supported in ${SOC_OPTEE_CONFIG_SUPPORTED}; do
        echo "# ${supported} boards" >> ${WORKDIR}/conf.external_dt
        for soc in ${STM32MP_SOC_NAME}; do
            soc_maj=$(echo ${soc} | awk '{print toupper($0)}')
            [ "$(echo ${soc_maj} | grep -c ${supported})" -ne 1 ] && continue
            dtb_by_soc=""
            for devicetree in ${dtb}; do
                [ "$(echo ${devicetree} | grep -c ${soc})" -eq 1 ] && dtb_by_soc="${dtb_by_soc} ${devicetree}.dts"
            done
            echo "flavor_dts_file-${supported}-CUBEMX = ${dtb_by_soc}" >> ${WORKDIR}/conf.external_dt
            echo "flavorlist-${supported} += \$(flavor_dts_file-${supported}-CUBEMX)" >> ${WORKDIR}/conf.external_dt
        done
        echo "" >> ${WORKDIR}/conf.external_dt
    done
    echo "" >> ${WORKDIR}/conf.external_dt

    cp -f ${WORKDIR}/conf.external_dt ${STAGING_EXTDT_DIR}/${EXTDT_DIR_OPTEE}/conf.mk

}
python() {
    machine_overrides = d.getVar('MACHINEOVERRIDES').split(':')
    if "stm32mpcommonmx" in machine_overrides:
        d.appendVarFlag('do_configure', 'prefuncs', ' autogenerate_conf_for_external_dt_cubemx')
}

PACKAGE_INSTALL:remove = "stm32mp-extlinux u-boot-stm32mp u-boot-stm32mp-splash"
PACKAGE_INSTALL:append = " u-boot-stm32mp-olimex-env"

remove_dtb () {
    rm -rf ${IMAGE_ROOTFS}/stm32mp157d-olimex-mx.dtb
}
ROOTFS_POSTPROCESS_COMMAND += "remove_dtb;"
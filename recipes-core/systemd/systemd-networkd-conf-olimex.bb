LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=0b7a4c087d5c2621b36954126bffdb14"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://01-end0-static.network file://LICENSE"

do_install() {
    install -d ${D}${systemd_unitdir}/network/
    install -m 0644 ${WORKDIR}/01-end0-static.network ${D}${systemd_unitdir}/network/
}

FILES:${PN} += "${systemd_unitdir}/network"
SUMMARY = "basic init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "file://init \
          "

RDEPENDS:${PN} += "util-linux-blockdev"

S = "${WORKDIR}"

do_install() {
        install -m 0555 -d ${D}/dev
        mknod   -m 622     ${D}/dev/console c 5 1
        install -m 0555 -d ${D}/proc
        install -m 0555 -d ${D}/sys

        install -m 0755 -d ${D}/run
        install -m 1777 -d ${D}/tmp
        install -m 0755 -d ${D}/var

        install -m 0755 -d ${D}/etc
        ln -snf /proc/mounts ${D}/etc/mtab

        install -m 0755 -d ${D}/persist
        install -m 0755 -d ${D}/roots
        install -m 0755 -d ${D}/root-parts
        install -m 0755 -d ${D}/system

        install -m 0755 ${WORKDIR}/init ${D}/init
}

inherit allarch

FILES:${PN} = "/*"

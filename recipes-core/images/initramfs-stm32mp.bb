DESCRIPTION = "initial ramdisk image used during boot phase."
LICENSE = "MIT"

PACKAGE_INSTALL = "initramfs-start \
                   busybox \
                   e2fsprogs-e2fsck \
                   e2fsprogs-mke2fs \
                   base-passwd \
                   "

remove_alternative_files () {
    rm -rf ${IMAGE_ROOTFS}/usr/lib/opkg
}
ROOTFS_POSTPROCESS_COMMAND += "remove_alternative_files;"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

IMAGE_NAME_SUFFIX = ""
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

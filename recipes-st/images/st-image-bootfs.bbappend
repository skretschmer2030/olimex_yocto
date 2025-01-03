PACKAGE_INSTALL:remove = "stm32mp-extlinux u-boot-stm32mp u-boot-stm32mp-splash kernel-imagebootfs"
PACKAGE_INSTALL:append = " u-boot-stm32mp-olimex-env"

# bundled initramfs is not available as a package, because it's bundled
# after kernel packaging. So we take it from the deploy folder
# todo: check dependencies

add_fit_image_initramfs () {
    echo "SK:postinstall ${FLASHLAYOUT_DEPLOYDIR}"
    cp -v ${FLASHLAYOUT_DEPLOYDIR}/kernel/${KERNEL_IMAGETYPE}-${INITRAMFS_IMAGE_NAME}-${MACHINE} ${IMAGE_ROOTFS}/boot/${KERNEL_IMAGETYPE}
    ls -lh ${IMAGE_ROOTFS}
}

ROOTFS_POSTPROCESS_COMMAND += "add_fit_image_initramfs;"
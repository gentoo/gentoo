# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == sys-libs/glibc && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing O_PATH definitions..."
    sed -e '/define.*O_PATH/d' -i "${S}"/sysdeps/unix/sysv/linux/bits/fcntl-linux.h || die
fi

# Local Variables:
# mode: shell-script
# End:

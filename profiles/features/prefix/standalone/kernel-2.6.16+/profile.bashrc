# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing utimensat outputs..."
    sed -e '/UTIMENSAT=/d' -i "${S}"/Source/kwsys/CMakeLists.txt || die
elif [[ ${CATEGORY}/${PN} == dev-qt/qtcore && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing pipe2 definitions..."
    sed -e '/define.*HAVE_PIPE2/d' -i "${S}"/src/3rdparty/forkfd/forkfd.c || die
    einfo "Removing utimensat calls..."
    sed -e '/_POSIX_VERSION/s/defined(_POSIX_VERSION)/0/' -i "${S}"/qmake/library/ioutils.cpp || die
    einfo "Lower the minimal version of Linux..."
    sed -r -e 's/MINLINUX_PATCH[[:space:]]+28/MINLINUX_PATCH 18/' \
        -i "${S}"/src/corelib/global/minimum-linux_p.h || die
elif [[ ${CATEGORY}/${PN} == dev-lang/ocaml && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing dup3 and pipe2 definitions..."
    sed -e '/hasgot dup3/,/^fi/d;/hasgot pipe2/,/^fi/d' -i "${S}"/configure || die
fi

# Local Variables:
# mode: shell-script
# End:

# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing utimensat outputs..."
    sed -e '/UTIMENSAT=/d' -i ${S}/Source/kwsys/CMakeLists.txt || die
elif [[ ${CATEGORY}/${PN} == dev-qt/qtcore && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing pipe2 definitions..."
    sed -e '/define.*HAVE_PIPE2/d' -i ${S}/src/3rdparty/forkfd/forkfd.c || die
    einfo "Removing utimensat calls..."
    sed -e '/_POSIX_VERSION/s/defined(_POSIX_VERSION)/0/' -i ${S}/qmake/library/ioutils.cpp || die
fi

# Local Variables:
# mode: shell-script
# End:

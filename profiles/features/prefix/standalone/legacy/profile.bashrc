# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing utimensat outputs..."
    sed -i '/UTIMENSAT=/d' ${S}/Source/kwsys/CMakeLists.txt
fi

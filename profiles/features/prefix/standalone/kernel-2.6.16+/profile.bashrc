# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing utimensat outputs..."
    sed -e '/UTIMENSAT=/d' -i "${S}"/Source/kwsys/CMakeLists.txt || die
elif [[ ${CATEGORY}/${PN} == dev-qt/qtcore && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing pipe2 definitions..."
    sed -e '/define.*HAVE_PIPE2/d' -i "${S}"/src/3rdparty/forkfd/forkfd.c || die
    einfo "Removing utimensat calls..."
    sed -e '/_POSIX_VERSION/s/defined(_POSIX_VERSION)/0/' -i "${S}"/qmake/library/ioutils.cpp || die
elif [[ ${CATEGORY}/${PN} == dev-lang/ocaml && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing dup3 and pipe2 definitions..."
    sed -e '/hasgot dup3/,/^fi/d;/hasgot pipe2/,/^fi/d' -i "${S}"/configure || die
elif [[ ${CATEGORY}/${PN} == sys-libs/glibc && ${EBUILD_PHASE} == compile ]]; then
    einfo "Removing F_DUPFD_CLOEXEC definitions..."
    sed -e '/define.*F_DUPFD_CLOEXEC/,/*\//d' -i "${S}"/sysdeps/unix/sysv/linux/bits/fcntl-linux.h || die
    einfo "Removing pipe2 definitions..."
    sed -e '/^extern int pipe2/d' -i "${S}"/posix/unistd.h || die
    einfo "Removing epoll_create1 definitions..."
    sed -e '/^extern int epoll_create1/d' -i "${S}"/sysdeps/unix/sysv/linux/sys/epoll.h || die
    einfo "Removing lutimes and utimensat definitions..."
    sed -e '/^extern int lutimes/,/__THROW/d' -i "${S}"/time/sys/time.h || die
    sed -e '/^extern int utimensat/,/__THROW/d' -i "${S}"/io/sys/stat.h || die
fi

# Local Variables:
# mode: shell-script
# End:

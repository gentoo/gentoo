# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# tricks to circumvent false positive checks of old kernel

if [[ ${CATEGORY}/${PN} == dev-util/cmake && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing utimensat outputs..."
    sed -e '/UTIMENSAT=/d' -i "${S}"/Source/kwsys/CMakeLists.txt || die
elif [[ ${CATEGORY}/${PN} == dev-libs/libuv && ${EBUILD_PHASE} == prepare ]]; then
    einfo "Removing CLOEXEC related functions..."
    sed -e 's/defined(__FreeBSD__) || defined(__linux__)/0/' \
        -i "${S}"/src/unix/process.c || die
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
elif [[ ${CATEGORY}/${PN} == sys-apps/util-linux && ${EBUILD_PHASE} == configure ]]; then
    einfo "Removing CLOEXEC related functions..."
    sed -r -e 's/inotify_init1\(.*\)/inotify_init\(\)/' \
	-e '/open\(/s/\| *O_CLOEXEC//' \
	-e 's/epoll_create1\(EPOLL_CLOEXEC/epoll_create\(1/' \
	-i "${S}"/libmount/src/monitor.c || die
fi

# Local Variables:
# mode: shell-script
# End:

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: netsurf.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Handle buildsystem of www.netsurf-browser.org components
# @DESCRIPTION:
# Handle settings build environment for netsurf build system

case "${EAPI:-0}" in
    7|8) ;;
    *) die "EAPI=${EAPI} is not supported" ;;
esac

inherit toolchain-funcs

# @FUNCTION: netsurf_define_makeconf
# @USAGE:
# @DESCRIPTION:
# This function sets NETSURF_MAKECONF as needed by the netsurf build system
netsurf_define_makeconf() {
	NETSURF_MAKECONF=(
		PREFIX="${EPREFIX}/usr"
		NSSHARED="${EPREFIX}/usr/share/netsurf-buildsystem"
		LIBDIR="$(get_libdir)"
		Q=
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		HOST_CC="\$(CC)"
		BUILD_CC="$(tc-getBUILD_CC)"
		CXX="$(tc-getCXX)"
		BUILD_CXX="$(tc-getBUILD_CXX)"
		CCOPT=
		CCNOOPT=
		CCDBG=
		LDDBG=
		WARNFLAGS=
	)
}

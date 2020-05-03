#!/bin/bash

netsurf_define_makeconf() {
	NETSURF_MAKECONF=(
		NSSHARED="${EROOT}"/usr/share/netsurf-buildsystem
		LIBDIR="$(get_libdir)"
		PREFIX="${EROOT}/usr"
		Q=
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
		AR="$(tc-getAR)"
		WARNFLAGS=
	)
}

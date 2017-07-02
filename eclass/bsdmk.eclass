# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bsdmk.eclass
# @MAINTAINER:
# bsd@gentoo.org
# @BLURB: Some functions for BSDmake

inherit toolchain-funcs portability flag-o-matic

EXPORT_FUNCTIONS src_compile src_install

RDEPEND=""
# this should actually be BDEPEND, but this works.
DEPEND="virtual/pmake"

ESED="/usr/bin/sed"

# @ECLASS-VARIABLE: mymakeopts
# @DESCRIPTION:
# Options for bsd-make

# @FUNCTION: append-opt
# @USAGE: < options >
# @DESCRIPTION:
# append options to enable or disable features
append-opt() {
	mymakeopts="${mymakeopts} $@"
}

# @FUNCTION: mkmake
# @USAGE: [ options ]
# @DESCRIPTION:
# calls bsd-make command with the given options, passing ${mymakeopts} to
# enable ports to useflags bridge.
mkmake() {
	[[ -z ${BMAKE} ]] && BMAKE="$(get_bmake)"

	tc-export CC CXX LD RANLIB

	${BMAKE} ${MAKEOPTS} ${EXTRA_EMAKE} ${mymakeopts} NO_WERROR= STRIP= "$@"
}

# @FUNCTION: mkinstall
# @USAGE: [ options ]
# @DESCRIPTION:
# Calls "bsd-make install" with the given options, passing ${mamakeopts} to
# enable ports to useflags bridge
mkinstall() {
	[[ -z ${BMAKE} ]] && BMAKE="$(get_bmake)"

	# STRIP= will replace the default value of -s, leaving to portage the
	# task of stripping executables.
	${BMAKE} ${mymakeopts} NO_WERROR= STRIP= MANSUBDIR= DESTDIR="${D}" "$@" install
}

# @FUNCTION: dummy_mk
# @USAGE: < dirnames >
# @DESCRIPTION:
# removes the specified subdirectories and creates a dummy makefile in them
# useful to remove the need for "minimal" patches
dummy_mk() {
	for dir in $@; do
		[ -d ${dir} ] || ewarn "dummy_mk called on a non-existing directory: $dir"
		[ -f ${dir}/Makefile ] || ewarn "dummy_mk called on a directory without Makefile: $dir"
		echo ".include <bsd.lib.mk>" > ${dir}/Makefile
	done
}

# @FUNCTION: bsdmk_src_compile
# @DESCRIPTION:
# The bsdmk src_compile function, which is exported
bsdmk_src_compile() {
	mkmake "$@" || die "make failed"
}

# @FUNCTION: bsdmk_src_install
# @DESCRIPTION:
# The bsdmk src_install function, which is exported
bsdmk_src_install() {
	mkinstall "$@" || die "install failed"
}

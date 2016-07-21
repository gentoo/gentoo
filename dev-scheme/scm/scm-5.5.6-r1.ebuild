# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit versionator eutils flag-o-matic multilib

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(get_version_component_range 1)${trarr:$(get_version_component_range 2):1}$(get_version_component_range 3)"

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${PN}
DESCRIPTION="SCM is a Scheme implementation from the author of slib"
SRC_URI="http://groups.csail.mit.edu/mac/ftpdir/scm/${MY_P}.zip"
HOMEPAGE="http://swiss.csail.mit.edu/~jaffer/SCM"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
IUSE="arrays bignums cautious dynamic-linking engineering-notation gsubr inexact
ioext macro ncurses posix readline regex sockets unix"

#unzip for unpacking
DEPEND="app-arch/unzip
	>=dev-scheme/slib-3.1.5
	dev-util/cproto
	ncurses? ( sys-libs/ncurses )
	readline? ( sys-libs/libtermcap-compat )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-multiplefixes.patch
}

src_compile() {
	# SLIB is required to build SCM.
	local slibpath="${EPREFIX}/usr/share/slib/"
	if [ -n "$SCHEME_LIBRARY_PATH" ]; then
		einfo "using SLIB $SCHEME_LIBRARY_PATH"
	elif [ -d ${slibpath} ]; then
		export SCHEME_LIBRARY_PATH=${slibpath}
	fi

	einfo "Making scmlit"
	emake -j1 scmlit clean || die "faild to build scmlit"

	einfo "Building scm"
	local features=""
	use arrays && features+="arrays"
	use bignums && features+=" bignums"
	use cautious && features+=" cautious"
	use engineering-notation && features+=" engineering-notation"
	use inexact && features+=" inexact"
	use macro && features+=" macro"

	( use readline ||
	  use ncurses ||
	  use regex ||
	  use posix ||
	  use ioext ||
	  use gsubr ||
	  use sockets ||
	  use unix ||
	  use dynamic-linking ) && features+=" dynamic-linking"

	./build \
		--compiler-options="${CFLAGS}" \
		--linker-options="${LDFLAGS} -L${EPREFIX}/$(get_libdir)" \
		-s "${EPREFIX}"/usr/$(get_libdir)/scm \
		-F ${features:="none"} \
		-h system \
		-o scm || die

	einfo "Building DLLs"
	if use readline; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-h system \
			-F edit-line \
			-t dll || die
	fi
	if use ncurses ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-F curses \
			-h system \
			-t dll || die
	fi
	if use regex ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c rgx.c \
			-h system \
			-t dll || die
	fi
	if use gsubr ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c gsubr.c \
			-h system \
			-t dll || die
	fi
	if use ioext ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c ioext.c \
			-h system \
			-t dll || die
	fi
	if use posix; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c posix.c \
			-h system \
			-t dll || die
	fi
	if use sockets ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c socket.c \
			-h system \
			-t dll || die
	fi
	if use unix ; then
		./build \
			--compiler-options="${CFLAGS}" \
			--linker-options="${LDFLAGS}" \
			-c unix.c \
			-h system \
			-t dll || die
	fi
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" man1dir=/usr/share/man/man1/ install || die "Install failed"

	doinfo scm.info
	doinfo hobbit.info
}

pkg_postinst() {
	[ "${ROOT}" == "/" ] && pkg_config
}

pkg_config() {
	einfo "Regenerating catalog..."
	scm -e "(require 'new-catalog)"
}

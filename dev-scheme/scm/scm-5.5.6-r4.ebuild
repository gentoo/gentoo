# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(ver_cut 1)${trarr:$(ver_cut 2):1}$(ver_cut 3)"
MY_P=${PN}-${MY_PV}

inherit toolchain-funcs

DESCRIPTION="SCM is a Scheme implementation from the author of slib"
HOMEPAGE="http://swiss.csail.mit.edu/~jaffer/SCM"
SRC_URI="http://groups.csail.mit.edu/mac/ftpdir/scm/${MY_P}.zip"
S=${WORKDIR}/${PN}

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="arrays bignums cautious dynamic-linking engineering-notation gsubr inexact ioext libscm macro ncurses posix readline regex sockets unix"

BDEPEND="app-arch/unzip"
DEPEND=">=dev-scheme/slib-3.1.5
	dev-util/cproto
	ncurses? ( sys-libs/ncurses:0= )
	readline? ( sys-libs/libtermcap-compat )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-multiplefixes.patch"
	"${FILESDIR}/${P}-respect-ldflags.patch" )

src_prepare() {
	default

	sed \
		-e "s|\"gcc\"|\"$(tc-getCC)\"|g" \
		-e "s|\"ld\"|\"$(tc-getLD)\"|g" \
		-i ./build.scm || die
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
	emake -j1 CC=$(tc-getCC) scmlit clean

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

	if use libscm ; then
		emake libscm.a
	fi
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" man1dir="${EPREFIX}"/usr/share/man/man1/ \
		install

	if use libscm; then
		emake DESTDIR="${D}" libdir="${EPREFIX}"/usr/$(get_libdir)/ \
			installlib
	fi

	doinfo scm.info
	doinfo hobbit.info
}

regen_catalog() {
	einfo "Regenerating catalog..."
	scm -e "(require 'new-catalog)"
}

pkg_postinst() {
	[[ -z ${ROOT} ]] && regen_catalog
}

pkg_config() {
	regen_catalog
}

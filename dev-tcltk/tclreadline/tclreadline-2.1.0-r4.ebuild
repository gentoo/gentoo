# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib toolchain-funcs

DEBIAN_PATCH=12

DESCRIPTION="Readline extension to TCL"
HOMEPAGE="http://tclreadline.sf.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}-${DEBIAN_PATCH}.debian.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	dev-lang/tcl:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gold.patch
	"${FILESDIR}"/${P}-alloc-free.patch
	"${FILESDIR}"/${P}-rl-executing-macro.patch
	"${FILESDIR}"/${P}-rl-history-expand.patch
	"${FILESDIR}"/${P}-rl-prompt.patch
	"${WORKDIR}"/debian/patches/complete_nontcl.patch
	"${WORKDIR}"/debian/patches/completion_matches.patch
	"${WORKDIR}"/debian/patches/completion_pbug.patch
	"${WORKDIR}"/debian/patches/kfreebsd.patch
	"${WORKDIR}"/debian/patches/link.patch
	"${WORKDIR}"/debian/patches/manpage.patch
	"${WORKDIR}"/debian/patches/memuse.patch
#	"${WORKDIR}"/debian/patches/tclrldir.patch
	"${WORKDIR}"/debian/patches/tclshpath.patch
	"${WORKDIR}"/debian/patches/tinfo.patch
	"${WORKDIR}"/debian/patches/varnames.patch

	)

src_prepare() {
	sed \
		-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" \
		-e "/^TCLRL_LIBDIR/s:lib:$(get_libdir):g" \
		-i configure.in || die
	mv configure.{in,ac} || die
	sed \
		-e 's:configure.in:configure.ac:g' \
		-i "${WORKDIR}"/debian/patches/* || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-tcl-includes="${EPREFIX}/usr/include"
		--with-readline-includes="${EPREFIX}/usr/include"
		--with-readline-library="-lreadline"
		)
	autotools-utils_src_configure
}

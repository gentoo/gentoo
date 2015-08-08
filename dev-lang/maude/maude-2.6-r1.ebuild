# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils versionator

MYP="${PN/m/M}-$(get_version_component_range 1-2)"

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="http://maude.cs.uiuc.edu/"
SRC_URI="
	http://maude.cs.uiuc.edu/download/current/${MYP}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${P}-extras.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	>=dev-libs/gmp-4.1.3
	dev-libs/libsigsegv
	dev-libs/libtecla
	sci-libs/buddy"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-prll.patch
	"${FILESDIR}"/${PN}-2.6-search-datadir.patch
	"${FILESDIR}"/${PN}-2.6-gcc47.patch
)

src_configure() {
	local myeconfargs=(
		--datadir="${EPREFIX}/usr/share/${PN}"
	)
	sed -i -e "s:/usr:${EPREFIX}/usr:g" src/Mixfix/global.hh || die
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# install data and full maude
	insinto /usr/share/${PN}
	doins -r src/Main/*.maude
	doins "${WORKDIR}"/${P}-extras/full-maude.maude

	# install docs and examples
	use doc && doins -r "${WORKDIR}"/${P}-extras/pdfs/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/${P}-extras/{manual,primer}-examples
	fi
}

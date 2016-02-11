# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools versionator

MYP="${PN/m/M}-$(get_version_component_range 1-2)"

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="http://maude.cs.uiuc.edu/"
SRC_URI="
	http://maude.cs.illinois.edu/w/images/2/2d/${MYP}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}-2.6-extras.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/libsigsegv
	dev-libs/libtecla
	sci-libs/buddy"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-prll.patch"
	"${FILESDIR}/${PN}-2.6-search-datadir.patch"
	"${FILESDIR}/${PN}-2.7-bison-parse-param.patch"
)

src_prepare() {
	default
	sed -i -e "s:/usr:${EPREFIX}/usr:g" src/Mixfix/global.hh || die
	eautoreconf
}

src_install() {
	default

	# install data and full maude
	insinto /usr/share/${PN}
	doins -r src/Main/*.maude
	doins "${WORKDIR}"/${PN}-2.6-extras/full-maude.maude

	# install docs and examples
	use doc && dodoc "${WORKDIR}"/${PN}-2.6-extras/pdfs/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/${PN}-2.6-extras/{manual,primer}-examples
	fi
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A fullscreen RPN calculator for the console"
HOMEPAGE="http://pessimization.com/software/orpie/"
SRC_URI="http://pessimization.com/software/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-ml/gsl-ocaml
	sys-libs/ncurses:0=
	|| ( <dev-lang/ocaml-4.02 dev-ml/camlp4 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.1-ocaml311.patch"
	"${FILESDIR}/${P}-nogsl.patch"
	"${FILESDIR}/${PN}-1.5.1-orpierc.patch"
	"${FILESDIR}/${PN}-1.5.1-tinfo.patch"
)

src_prepare() {
	default
	sed -i -e "s:/usr:${EPREFIX}/usr:g" Makefile.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	# TODO: fix missing edges in dependency graph
	emake -j1
}

src_install() {
	default
	if use doc; then
		dodoc doc/manual.pdf
		docinto html/
		dodoc doc/manual.html
	fi
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	dev-ml/camlp4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.1-ocaml311.patch"
	"${FILESDIR}/${PN}-1.5.2-nogsl.patch"
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
	if use doc; then
		dodoc doc/manual.pdf
		HTML_DOCS=( doc/manual.html )
	fi
	default
}

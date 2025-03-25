# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A fullscreen RPN calculator for the console"
HOMEPAGE="http://pessimization.com/software/orpie/"
SRC_URI="https://github.com/pelzlpj/${PN}/archive/release-${PV}.tar.gz"

S="${WORKDIR}"/${PN}-release-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="dev-ml/gsl-ocaml:=
	dev-ml/curses:=
	dev-ml/num:=
	dev-ml/camlp5":=
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-orpierc.patch
	"${FILESDIR}"/${P}-rcfile.patch
	"${FILESDIR}"/${P}-ocaml5.patch
)

src_compile() {
	PREFIX=/usr dune_src_compile
}

src_install() {
	dune_src_install
	mv "${D}"/{/usr,}/etc || die
}

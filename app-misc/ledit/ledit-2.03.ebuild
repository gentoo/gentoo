# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

RESTRICT="installsources"
IUSE="+ocamlopt"

DESCRIPTION="A line editor to be used with interactive commands"
SRC_URI="http://pauillac.inria.fr/~ddr/ledit/distrib/src/${P}.tgz"
HOMEPAGE="http://pauillac.inria.fr/~ddr/ledit/"

DEPEND=">=dev-lang/ocaml-3.09:=[ocamlopt?]
	dev-ml/camlp5:="
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ppc x86"
RESTRICT="!ocamlopt? ( strip )"

src_compile() {
	emake -j1 all
	if use ocamlopt; then
		emake -j1 ledit.opt
	fi
}

src_install() {
	if use ocamlopt; then
		newbin ledit.opt ledit
	else
		newbin ledit.out ledit
	fi
	doman ledit.1
	dodoc CHANGES README
}

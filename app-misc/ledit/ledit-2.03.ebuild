# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A line editor to be used with interactive commands"
SRC_URI="http://pauillac.inria.fr/~ddr/ledit/distrib/src/${P}.tgz"
HOMEPAGE="http://pauillac.inria.fr/~ddr/ledit/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+ocamlopt"
RESTRICT="installsources !ocamlopt? ( strip )"

DEPEND=">=dev-lang/ocaml-3.09:=[ocamlopt?]
	dev-ml/camlp5:="
RDEPEND="${DEPEND}"

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

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A line editor to be used with interactive commands"
HOMEPAGE="http://pauillac.inria.fr/~ddr/ledit/"
SRC_URI="http://pauillac.inria.fr/~ddr/ledit/distrib/src/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+ocamlopt"

RESTRICT="installsources !ocamlopt? ( strip )"

DEPEND=">=dev-lang/ocaml-3.09:=[ocamlopt?]
	dev-ml/camlp5:="
RDEPEND="${DEPEND}"

# For explanation please follow the link below.
# https://github.com/gentoo/gentoo/pull/14865#issuecomment-605697524
QA_FLAGS_IGNORED="/usr/bin/ledit"

PATCHES=( "${FILESDIR}"/${P}-ocaml4.09.patch )

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

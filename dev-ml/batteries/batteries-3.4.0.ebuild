# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="A community-maintained standard library extension"
HOMEPAGE="https://github.com/ocaml-batteries-team/batteries-included"
SRC_URI="https://github.com/ocaml-batteries-team/batteries-included/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}
	dev-ml/num:="
BDEPEND="dev-ml/ocamlbuild"

S="${WORKDIR}"/batteries-included-${PV}

src_compile() {
	emake BATTERIES_NATIVE=$(usex ocamlopt yes no)
}

src_install() {
	findlib_src_install BATTERIES_NATIVE=$(usex ocamlopt yes no)
}

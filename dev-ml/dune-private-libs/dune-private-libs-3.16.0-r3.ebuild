# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Private libraries of Dune"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz
	-> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND=">=dev-ml/dune-3.12"
DEPEND="
	dev-ml/csexp:=[ocamlopt?]
"
RDEPEND="${DEPEND}
	!dev-ml/stdune
	!dev-ml/dyn
	!dev-ml/ordering
"

src_configure() {
	:
}

src_compile() {
	dune-compile ordering dyn stdune ${PN}
}

src_install() {
	dune-install ordering dyn stdune ${PN}
}

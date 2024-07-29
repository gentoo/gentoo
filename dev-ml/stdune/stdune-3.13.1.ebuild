# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Dune's unstable standard library"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz
	-> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND=">=dev-ml/dune-3.5"
DEPEND="
	~dev-ml/dyn-${PV}:=[ocamlopt?]
	~dev-ml/ordering-${PV}:=[ocamlopt?]
	dev-ml/pp:=[ocamlopt?]
	dev-ml/csexp:=[ocamlopt?]
	!<dev-ml/dune-private-libs-3
"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	dune-compile ${PN}
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune multiprocessing

DESCRIPTION="Private libraries of Dune"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz
	-> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND=">=dev-ml/dune-3.5"
DEPEND="
	>=dev-ml/csexp-1.5:=[ocamlopt?]
	dev-ml/pp:=[ocamlopt?]
	~dev-ml/dyn-${PV}:=[ocamlopt?]
	~dev-ml/stdune-${PV}:=[ocamlopt?]
	>=dev-lang/ocaml-4.08
"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	dune build -p "${PN}" @install -j $(makeopts_jobs) --profile release || die
}

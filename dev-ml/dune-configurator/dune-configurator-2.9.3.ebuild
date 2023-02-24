# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"
RESTRICT="test" #test run within dev-ml/dune-private-libs

RDEPEND="
	~dev-ml/dune-private-libs-${PV}:=[ocamlopt?]
	dev-ml/csexp:=[ocamlopt?]
	dev-ml/result:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

src_configure() {
	:
}

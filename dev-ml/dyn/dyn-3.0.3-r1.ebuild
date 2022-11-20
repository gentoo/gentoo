# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune multiprocessing

DESCRIPTION="Dynamic type"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND=">=dev-ml/dune-3"
DEPEND="~dev-ml/ordering-${PV}:=
	dev-ml/pp:="
RDEPEND="${DEPEND}"

src_configure() {
	./configure \
		--libdir="$(ocamlc -where)" \
		--mandir="/usr/share/man" \
		|| die
}

src_compile() {
	dune build -p "${PN}" @install -j $(makeopts_jobs) --profile release || die
}

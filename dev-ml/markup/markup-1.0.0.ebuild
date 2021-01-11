# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam multiprocessing

DESCRIPTION="Error-recovering streaming HTML5 and XML parsers"
HOMEPAGE="https://github.com/aantron/markup.ml"
SRC_URI="https://github.com/aantron/markup.ml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

RDEPEND="dev-lang/ocaml:="
BDEPEND=">=dev-ml/dune-2.7
	dev-lang/ocaml"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}.ml-${PV}"

src_compile() {
	dune build -p "${PN}" -j $(makeopts_jobs) @install || die
}

src_test() {
	dune runtest -p "${PN}" -j $(makeopts_jobs) || die
}

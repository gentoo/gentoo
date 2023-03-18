# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune multiprocessing

DESCRIPTION="Embed locations informations inside executable and libraries"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc64 x86"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	~dev-ml/dune-private-libs-${PV}:=[ocamlopt=]
"
DEPEND="${RDEPEND}"

src_configure() {
	:
}

src_compile() {
	dune build -p ${PN} @install -j $(makeopts_jobs) --display short || die
}

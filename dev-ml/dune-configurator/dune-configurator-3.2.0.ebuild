# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune multiprocessing

DESCRIPTION="Helper library for gathering system configuration"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

BDEPEND=">=dev-ml/dune-3"
DEPEND="
	>=dev-ml/csexp-1.5:=[ocamlopt?]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# This enables dune-configurator to use the vendored csexp module
	sed -i 's/stdune.csexp/dune-configurator.csexp/' \
		vendor/csexp/src/dune || die
}

src_configure() {
	:
}

src_compile() {
	dune build -p "${PN}" @install -j $(makeopts_jobs) --profile release || die
}

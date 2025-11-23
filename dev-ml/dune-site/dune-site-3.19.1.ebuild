# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Embed locations informations inside executable and libraries"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz
	-> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	>=dev-ml/dune-3.12
	dev-ml/csexp:=[ocamlopt?]
	!dev-ml/dune-private-libs
	!dev-ml/stdune
	!dev-ml/dyn
	!dev-ml/ordering
"
DEPEND="${RDEPEND}"

src_configure() {
	:
}

src_compile() {
	dune-compile ordering dyn stdune dune-private-libs ${PN}
}

src_install() {
	dune-install ordering dyn stdune dune-private-libs ${PN}
}

# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="tar"
inherit dune

DESCRIPTION="Decode and encode tar format files in pure OCaml"
HOMEPAGE="https://github.com/mirage/ocaml-tar"
SRC_URI="https://github.com/mirage/ocaml-tar/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/decompress:=[ocamlopt?]
	dev-ml/fpath
	dev-ml/logs:=[ocamlopt?]
	>=dev-ml/lwt-5.7.0:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

DUNE_PACKAGES=(
	tar
	tar-unix
)

src_compile() {
	dune-compile ${DUNE_PACKAGES[@]}
}

src_test() {
	dune-test ${DUNE_PACKAGES[@]}
}

src_install() {
	dune-install ${DUNE_PACKAGES[@]}

	einstalldocs
}

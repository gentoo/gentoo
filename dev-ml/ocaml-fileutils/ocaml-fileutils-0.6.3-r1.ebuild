# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="fileutils"

inherit dune

DESCRIPTION="Pure OCaml functions to manipulate real file (POSIX like) and filename"
HOMEPAGE="https://github.com/gildor478/ocaml-fileutils"
SRC_URI="https://github.com/gildor478/${PN}/releases/download/v${PV}/${DUNE_PKG_NAME}-v${PV}.tbz -> ${P}.tar.bz2"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+ocamlopt"

DEPEND=">=dev-ml/ounit2-2.0.0
	>=dev-ml/stdlib-shims-0.2.0"
RDEPEND="${DEPEND}"

DOCS=( "README.md" "CHANGES.md" "LICENSE.txt" )

S="${WORKDIR}/${DUNE_PKG_NAME}-v${PV}"

src_prepare() {
	default

	# Port to dev-ml/ounit2
	sed -i -e 's/oUnit/ounit2/' test/dune || die
}

# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DUNE_PKG_NAME=crunch
inherit dune

DESCRIPTION="Convert a filesystem into a static OCaml module"
HOMEPAGE="https://github.com/mirage/ocaml-crunch"
SRC_URI="https://github.com/mirage/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt"
RESTRICT="test"

DEPEND="
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/ptime:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-ml/dune-2.5"

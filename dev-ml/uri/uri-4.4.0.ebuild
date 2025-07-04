# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="An RFC3986 URI/URL parsing library"
HOMEPAGE="https://github.com/mirage/ocaml-uri"
SRC_URI="https://github.com/mirage/ocaml-uri/releases/download/v${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	dev-ml/angstrom:=[ocamlopt?]
	dev-ml/core_bench:=[ocamlopt?]
	dev-ml/core_unix:=[ocamlopt?]
	dev-ml/stringext:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

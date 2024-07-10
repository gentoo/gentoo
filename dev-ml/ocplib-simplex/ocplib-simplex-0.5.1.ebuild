# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A library implementing a simplex algorithm"
HOMEPAGE="https://github.com/OCamlPro-Iguernlala/ocplib-simplex"
SRC_URI="https://github.com/OCamlPro-Iguernlala/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/findlib:=[ocamlopt?]
	dev-ml/logs:=[ocamlopt?]
"
BDEPEND="test? ( dev-ml/zarith )"

DOCS=( CHANGES.md README.md extra/simplex_invariants.txt extra/TODO.txt )

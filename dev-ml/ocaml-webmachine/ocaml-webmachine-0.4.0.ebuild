# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="A REST toolkit for OCaml"
HOMEPAGE="https://github.com/inhabitedtype/ocaml-webmachine"
SRC_URI="https://github.com/inhabitedtype/ocaml-webmachine/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/calendar:=
	dev-ml/ocaml-cohttp:=[ocamlopt?]
	dev-ml/ocaml-dispatch:=[ocamlopt?]
	dev-ml/ocaml-re:=[ocamlopt?]
	dev-ml/ocaml-uri:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/ounit[ocamlopt?] )
"

DOCS=( README.md CONTRIBUTING.md )

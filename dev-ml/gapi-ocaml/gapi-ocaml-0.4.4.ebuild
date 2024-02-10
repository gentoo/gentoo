# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune findlib

DESCRIPTION="A simple OCaml client for Google Services"
HOMEPAGE="
	https://opam.ocaml.org/packages/gapi-ocaml/
	https://github.com/astrada/gapi-ocaml
"

SRC_URI="https://github.com/astrada/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="ocamlopt test"

RDEPEND="
	dev-ml/ocurl:=
	>=dev-ml/ocamlnet-4.1.4:=
	dev-ml/cryptokit:=
	dev-ml/yojson:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-ml/ounit2 )
"

RESTRICT="!test? ( test )"

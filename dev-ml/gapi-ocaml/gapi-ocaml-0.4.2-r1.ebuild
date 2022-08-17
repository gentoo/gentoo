# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	<dev-ml/yojson-2:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-ml/ounit2 )
"

RESTRICT="!test? ( test )"
PATCHES=( "${FILESDIR}/${P}-ounit2.patch" )

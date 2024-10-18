# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="JSON codec generator for OCaml"
HOMEPAGE="https://github.com/ocaml-ppx/ppx_deriving_yojson/"
SRC_URI="https://github.com/ocaml-ppx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/ppxlib-0.30.0:=[ocamlopt?]
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/yojson:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

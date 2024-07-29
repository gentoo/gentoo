# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	>=dev-ml/ppxlib-0.26.0:=
	dev-ml/ppx_deriving:=
	dev-ml/result:=
	dev-ml/yojson:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

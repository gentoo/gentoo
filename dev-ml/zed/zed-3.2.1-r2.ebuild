# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Abstract engine for text edition in OCaml"
HOMEPAGE="https://github.com/ocaml-community/zed"
SRC_URI="https://github.com/ocaml-community/zed/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/dune-3
	dev-ml/react:=
	dev-ml/result:=
	dev-ml/uchar:=
	dev-ml/uucp:=
	dev-ml/uuseg:=
	dev-ml/uutf:=
"
DEPEND="${RDEPEND}"

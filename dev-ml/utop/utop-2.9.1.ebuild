# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Universal toplevel for OCaml"
HOMEPAGE="https://github.com/ocaml-community/utop"
SRC_URI="https://github.com/ocaml-community/utop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/camomile:=
	dev-ml/lambda-term:=
	dev-ml/lwt:=
	dev-ml/react:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/cppo
	dev-ml/findlib
"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Terminal manipulation library for OCaml"
HOMEPAGE="https://github.com/ocaml-community/lambda-term"
SRC_URI="https://github.com/ocaml-community/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/camomile:=
	>=dev-ml/lwt-5.4:=
	dev-ml/lwt_log:=
	dev-ml/mew_vi:=
	dev-ml/react:=
	dev-ml/zed:=
"
DEPEND="${RDEPEND}"

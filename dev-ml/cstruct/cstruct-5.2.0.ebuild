# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

MYP=${PN}-v${PV}

DESCRIPTION="Map OCaml arrays onto C-like structs"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct https://mirage.io"
SRC_URI="https://github.com/mirage/ocaml-${PN}/releases/download/v${PV}/${MYP}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-ml/async_unix:=
	dev-ml/bigarray-compat:=
	>=dev-ml/ppx_tools_versioned-5.4.0:="
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MYP}

# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=lablgtk3
MY_P="${MY_PN}-${PV}"
DUNE_PKG_NAME=${MY_PN}-sourceview3
inherit dune

DESCRIPTION="OCaml bindings to GTK-3"
HOMEPAGE="https://github.com/garrigue/lablgtk"
SRC_URI="https://github.com/garrigue/lablgtk/releases/download/${PV}/${MY_P}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="3/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	x11-libs/gtksourceview:3.0=
	>=dev-ml/lablgtk-${PV}:3=
		dev-ml/cairo2:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME=lablgtk3
inherit dune

DESCRIPTION="OCaml bindings to GTK-3"
HOMEPAGE="https://github.com/garrigue/lablgtk"
SRC_URI="https://github.com/garrigue/lablgtk/releases/download/${PV}/${DUNE_PKG_NAME}-${PV}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="3/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+ocamlopt sourceview"

BDEPEND="dev-ml/camlp5"
DEPEND="
	app-text/gtkspell:3=
	x11-libs/gtk+:3=
	dev-ml/cairo2:=
"
RDEPEND="${DEPEND}"
PDEPEND="sourceview? ( dev-ml/lablgtk-sourceview:${SLOT} )"

S="${WORKDIR}/${DUNE_PKG_NAME}-${PV}"

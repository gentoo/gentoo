# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=lablgtk3

inherit dune

DESCRIPTION="OCaml bindings to GTK-3"
HOMEPAGE="https://github.com/garrigue/lablgtk"
SRC_URI="https://github.com/garrigue/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="3/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ppc64 ~x86"
IUSE="+ocamlopt sourceview"

BDEPEND="dev-ml/camlp5"
DEPEND="
	app-text/gtkspell:3=
	x11-libs/gtk+:3=
	dev-ml/cairo2:=
	x11-libs/gtksourceview:3.0=
"
RDEPEND="${DEPEND}"
PDEPEND="sourceview? ( dev-ml/lablgtk-sourceview:${SLOT} )"

src_compile() {
	dune build --profile release -p ${DUNE_PKG_NAME} || die
}

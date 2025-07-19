# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=lablgtk3

inherit dune

DESCRIPTION="OCaml bindings to GTK-3"
HOMEPAGE="https://github.com/garrigue/lablgtk"
SRC_URI="https://github.com/garrigue/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="3/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt sourceview"

DEPEND="
	app-text/gtkspell:3=
	dev-ml/cairo2:=[ocamlopt?]
	dev-ml/camlp-streams:=[ocamlopt?]
	x11-libs/gtk+:3=[X]
	x11-libs/gtksourceview:3.0=
"
RDEPEND="${DEPEND}"
PDEPEND="sourceview? ( dev-ml/lablgtk-sourceview:${SLOT} )"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}

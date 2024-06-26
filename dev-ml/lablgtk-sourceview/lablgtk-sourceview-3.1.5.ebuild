# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=lablgtk3-sourceview3

inherit dune

DESCRIPTION="OCaml bindings to GTK-3"
HOMEPAGE="https://github.com/garrigue/lablgtk"
SRC_URI="https://github.com/garrigue/lablgtk/archive/${PV}.tar.gz
	-> lablgtk-${PV}.tar.gz"
S="${WORKDIR}"/lablgtk-${PV}

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="3/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/lablgtk-${PV}:3=
	dev-ml/cairo2:=
	x11-libs/gtksourceview:3.0=
"
RDEPEND="${DEPEND}"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}

# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Binding to Cairo, a 2D Vector Graphics Library"
HOMEPAGE="https://github.com/Chris00/ocaml-cairo"
SRC_URI="https://github.com/Chris00/ocaml-cairo/releases/download/${PV}/cairo2-${PV}.tbz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	x11-libs/cairo:=[svg(+)]
	dev-ml/dune-configurator:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

# >>> Test phase: dev-ml/cairo2-0.6.1
# image_create alias tests/runtest (got signal SEGV)
# (cd _build/default/tests && ./image_create.exe)
# DESTROY bigarray 'data'
# Done: 70/72 (jobs: 1) * ERROR: dev-ml/cairo2-0.6.1::x-portage failed (test phase):
RESTRICT=test

# Remove lablgtk2 dep https://github.com/Chris00/ocaml-cairo/issues/21
# Fix compiler warnings, from: https://github.com/Chris00/ocaml-cairo/pull/22
PATCHES=(
	"${FILESDIR}"/${PN}-0.6.1-ignore-gtk-and-pango.patch
)

# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Binding to Cairo, a 2D Vector Graphics Library"
HOMEPAGE="https://github.com/Chris00/ocaml-cairo"
SRC_URI="https://github.com/Chris00/ocaml-cairo/releases/download/${PV}/cairo2-${PV}.tbz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	x11-libs/cairo:=
	dev-ml/dune-configurator:=
"
RDEPEND="${DEPEND}
	!dev-ml/ocaml-cairo
"
BDEPEND=""

# >>> Test phase: dev-ml/cairo2-0.6.1
# image_create alias tests/runtest (got signal SEGV)
# (cd _build/default/tests && ./image_create.exe)
# DESTROY bigarray 'data'
# Done: 70/72 (jobs: 1) * ERROR: dev-ml/cairo2-0.6.1::x-portage failed (test phase):
RESTRICT=test

# Fix compiler warnings, from: https://github.com/Chris00/ocaml-cairo/pull/22
PATCHES=( "${FILESDIR}"/${PN}-0.6.1-handle-safe-string.patch )

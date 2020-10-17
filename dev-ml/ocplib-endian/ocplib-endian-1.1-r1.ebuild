# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Functions to read and write int16/32/64 from strings, bytes, and bigarrays"
HOMEPAGE="https://github.com/OCamlPro/ocplib-endian"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

# 2 of 70 tests fail
RESTRICT="test"

# see #748549 for version restriction on OCaml
BDEPEND="
	>=dev-lang/ocaml-4.07.0
	>=dev-ml/cppo-1.1.0
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-fix-build.patch"
)

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Optimised functions to read and write int16/32/64 from strings, bytes and bigarrays"
HOMEPAGE="https://github.com/OCamlPro/ocplib-endian"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-lang/ocaml-4.01
	>=dev-ml/cppo-1.1.0
"
RDEPEND=""

DOCS=( CHANGES.md COPYING.txt README.md )

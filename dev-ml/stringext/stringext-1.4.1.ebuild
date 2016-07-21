# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Extra string functions for OCaml"
HOMEPAGE="https://github.com/rgrinberg/stringext"
SRC_URI="https://github.com/rgrinberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	test? ( dev-ml/qcheck[ounit(-)] )
	>=dev-lang/ocaml-4:=
"
RDEPEND="
	>=dev-lang/ocaml-4:=
"

DOCS=( README.md )

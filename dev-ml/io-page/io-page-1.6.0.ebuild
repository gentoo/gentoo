# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="IO memory page library for Mirage backends"
HOMEPAGE="https://github.com/mirage/io-page https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-lang/ocaml-4:=
	>=dev-ml/ocaml-cstruct-1.1.0:=
"
DEPEND="
	test? ( dev-ml/ounit )
	${RDEPEND}
"

DOCS=( CHANGES README.md )

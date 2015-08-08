# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Regular expression library for OCaml"
HOMEPAGE="http://github.com/ocaml/ocaml-re"
SRC_URI="https://github.com/ocaml/ocaml-re/archive/${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-lang/ocaml-4.02:="
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"
DOCS=( "CHANGES" "TODO.txt" "README.md" )
S="${WORKDIR}/${PN}-${P}"

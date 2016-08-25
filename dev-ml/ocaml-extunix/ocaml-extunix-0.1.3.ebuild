# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Thin bindings to various low-level system APIs"
HOMEPAGE="http://extunix.forge.ocamlcore.org/"
SRC_URI="http://ygrek.org.ua/p/release/ocaml-extunix/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"
DOCS=( "README.md" "TODO" "CHANGES.txt" )

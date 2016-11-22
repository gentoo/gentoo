# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Pure OCaml functions to manipulate real file (POSIX like) and filename"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-fileutils"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1651/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-ml/ounit-2.0.0"

DOCS=( "AUTHORS.txt" "README.txt" "CHANGELOG.txt" "TODO.txt" )

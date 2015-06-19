# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-fileutils/ocaml-fileutils-0.4.5.ebuild,v 1.2 2013/08/24 13:18:41 maekke Exp $

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Pure OCaml functions to manipulate real file (POSIX like) and filename"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-fileutils"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1194/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ml/ounit"

DOCS=( "AUTHORS.txt" "README.txt" "CHANGELOG.txt" "TODO.txt" )

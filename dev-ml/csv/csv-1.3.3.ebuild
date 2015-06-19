# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/csv/csv-1.3.3.ebuild,v 1.1 2014/04/13 17:42:34 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="A pure OCaml library to read and write CSV files"
HOMEPAGE="http://forge.ocamlcore.org/projects/csv/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1376/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( "README.txt" "AUTHORS.txt" )

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocamlmod/ocamlmod-0.0.7.ebuild,v 1.1 2014/10/30 08:17:00 aballier Exp $

EAPI=5

#OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Generate OCaml modules from source files"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocamlmod/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1350/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
#	test? ( >=dev-ml/ounit-2.0.0 )"

DOCS=( "AUTHORS.txt" "README.txt" )

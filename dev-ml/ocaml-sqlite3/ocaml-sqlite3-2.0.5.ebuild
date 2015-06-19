# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-sqlite3/ocaml-sqlite3-2.0.5.ebuild,v 1.2 2014/08/10 20:43:12 slyfox Exp $

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

MY_PN="sqlite3-ocaml"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A package for ocaml that provides access to SQLite databases"
HOMEPAGE="http://bitbucket.org/mmottl/sqlite3-ocaml"
SRC_URI="http://bitbucket.org/mmottl/${MY_PN}/downloads/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-db/sqlite-3.3.3
	>=dev-ml/findlib-1.3.2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" "TODO.md" )

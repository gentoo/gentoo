# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-sqlite3/ocaml-sqlite3-2.0.7.ebuild,v 1.1 2014/11/28 15:18:55 aballier Exp $

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

MY_PN="sqlite3-ocaml"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A package for ocaml that provides access to SQLite databases"
HOMEPAGE="http://mmottl.github.io/sqlite3-ocaml/"
SRC_URI="https://github.com/mmottl/sqlite3-ocaml/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-db/sqlite-3.3.3
	>=dev-ml/findlib-1.3.2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" "TODO.md" )

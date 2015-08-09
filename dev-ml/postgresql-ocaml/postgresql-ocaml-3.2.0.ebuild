# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="A package for ocaml that provides access to PostgreSQL databases"
SRC_URI="https://github.com/mmottl/postgresql-ocaml/releases/download/v${PV}/${P}.tar.gz"
HOMEPAGE="http://mmottl.github.io/postgresql-ocaml/"
IUSE="examples"

RDEPEND="
	dev-db/postgresql:=[server]
"
DEPEND="${RDEPEND}
	>=dev-ml/findlib-1.5"

SLOT="0/${PV}"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" )

src_install() {
	oasis_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

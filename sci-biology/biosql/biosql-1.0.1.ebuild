# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A generic bioinformatics relational database model"
HOMEPAGE="http://www.biosql.org/"
SRC_URI="http://biosql.org/DIST/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
IUSE="mysql postgres"
KEYWORDS="amd64 x86"

# WARNING: bioperl-db is claimed to be incompatible with >=postgresql-8.3 (see INSTALL)

DEPEND="mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/${PN}
	doins -r sql scripts/* || die
	insinto /usr/share/doc/${P}
	doins -r doc/*
	dodoc Changes INSTALL README Release.txt
}

pkg_postinst() {
	echo
	elog "Please read the BioSQL schema installation instructions in"
	elog "/usr/share/doc/${P} to begin using the schema."
	echo
}

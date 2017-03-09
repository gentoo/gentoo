# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A generic bioinformatics relational database model"
HOMEPAGE="http://www.biosql.org/"
SRC_URI="http://biosql.org/DIST/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mysql postgres"

# WARNING: bioperl-db is claimed to be incompatible with >=postgresql-8.3 (see INSTALL)

DEPEND="
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )"
RDEPEND="
	${DEPEND}
	dev-lang/perl"

src_install() {
	insinto /usr/share/${PN}
	doins -r sql scripts/.

	dodoc Changes README Release.txt doc/*.pdf

	docinto biopython
	dodoc doc/{README,schema-overview.txt,biopython/{cor6_6.gb,*.pdf}}
	docompress -x /usr/share/doc/${PF}/biopython

	docinto html
	dodoc doc/{biopython/,}*.htm*
}

pkg_postinst() {
	elog
	elog "Please read the BioSQL schema installation instructions in"
	elog "${EROOT%/}/usr/share/doc/${PF} to begin using the schema."
	elog
}

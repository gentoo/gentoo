# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="SQL builder and data modeling layer"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="minimal"

# The MDB2/DB dependencies are listed as "optional," but really, you
# need one or the other. Prefer the newer MDB2 to the deprecated DB.
DEPEND=""
RDEPEND="|| ( dev-php/PEAR-MDB2 dev-php/PEAR-DB )
	dev-php/PEAR-Date
	!minimal? ( dev-php/PEAR-Validate )"
DOCS=( docs/example.ini )

src_prepare() {
	# Don't install this batch file -- it winds up in ${EPREFIX}/usr/bin.
	# Delete the line that mentions it from package.xml.
	sed -e '/DB_DataObject_createTables\.bat/d' \
		-i "${WORKDIR}/package.xml" \
		|| die "failed to remove batch file from package.xml"

	eapply_user
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides methods for dumping structured information about a variable"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=">=dev-lang/php-5.3"
RDEPEND="${DEPEND}"

src_install() {
	php-pear-r1_src_install
	# Remove the documenation generation binary that is specific to this package
	rm "${D}usr/bin/gen_php_doc.sh" || die
}

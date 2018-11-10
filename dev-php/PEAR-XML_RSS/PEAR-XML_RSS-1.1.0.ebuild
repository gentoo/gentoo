# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="PHP parser for RDF and RSS documents"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

# Only needs PEAR_Exception (not in the tree), not all of PEAR.
# This can be made into an || dependency if we add PEAR_Exception.
RDEPEND=">=dev-php/PEAR-PEAR-1.10.1
	dev-php/PEAR-XML_Parser"

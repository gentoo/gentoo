# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides methods for spelling numerals in words"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-5.3.2
	dev-php/PEAR-Math_BigInteger
	"

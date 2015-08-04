# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Numbers_Words/PEAR-Numbers_Words-0.18.1.ebuild,v 1.4 2015/08/04 12:33:48 zlogene Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides methods for spelling numerals in words"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-5.3.2
	dev-php/PEAR-Math_BigInteger
	"

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHP_PMD"
PHP_PEAR_URI="pear.phpmd.org"

inherit php-pear-lib-r1

DESCRIPTION="PHP mess detector"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.phpmd.org"

RDEPEND="${RDEPEND}
	>=dev-php/phpdepend-1.1.1"

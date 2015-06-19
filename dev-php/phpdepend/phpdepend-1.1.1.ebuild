# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpdepend/phpdepend-1.1.1.ebuild,v 1.1 2013/11/25 22:08:27 mabi Exp $

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHP_Depend"
PHP_PEAR_URI="pear.pdepend.org"

inherit php-pear-lib-r1

DESCRIPTION="Static code analyser for PHP"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.pdepend.org"

RDEPEND="${RDEPEND}
	>=dev-lang/php-5.2.3"

src_unpack() {
	# we only have one file in $A and it contains a lone zero block
	tar xf "${DISTDIR}/${A}" --ignore-zeros
}

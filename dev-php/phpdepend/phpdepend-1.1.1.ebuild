# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHP_Depend"
PHP_PEAR_URI="pear.pdepend.org"

inherit php-pear-lib-r1

DESCRIPTION="Static code analyser for PHP"
LICENSE="BSD"
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

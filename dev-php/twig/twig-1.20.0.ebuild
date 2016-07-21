# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="Twig"
PHP_PEAR_URI="pear.twig-project.org"
inherit php-pear-lib-r1

DESCRIPTION="PHP templating engine with syntax similar to Django"
HOMEPAGE="http://twig.sensiolabs.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodoc CHANGELOG README.rst
	php-pear-lib-r1_src_install
	rm -r "${D}"/usr/share/php/docs
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/propel-generator/propel-generator-1.6.4.ebuild,v 1.4 2014/08/10 21:05:09 slyfox Exp $

EAPI="4"
inherit php-pear-lib-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Object Persistence Layer for PHP 5 (Generator)"
HOMEPAGE="http://propelorm.org"
SRC_URI="http://pear.propelorm.org/get/propel_generator-${PV}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="dev-lang/php[pdo,xml,xslt]
		>=dev-php/pear-1.9.0-r1
"
RDEPEND="${DEPEND}
	>=dev-php/phing-2.3.0"

S="${WORKDIR}/propel_generator-${PV}"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phptal/phptal-1.2.2.ebuild,v 1.1 2014/01/06 17:26:14 mabi Exp $

EAPI=5

PHP_LIB_NAME="PHPTAL"

DESCRIPTION="A templating engine for PHP5 that implements Zope Page Templates syntax"
HOMEPAGE="http://phptal.org/"
SRC_URI="http://phptal.org/files/${PHP_LIB_NAME}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php"

S="${WORKDIR}/${PHP_LIB_NAME}-${PV}"

src_install() {
	insinto /usr/share/php/${PN}
	doins -r "${PHP_LIB_NAME}"
	doins PHPTAL.php phptal_lint.php

	dodoc README
}

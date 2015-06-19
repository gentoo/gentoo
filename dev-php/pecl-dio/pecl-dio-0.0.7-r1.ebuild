# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-dio/pecl-dio-0.0.7-r1.ebuild,v 1.1 2014/09/30 16:37:26 grknight Exp $

EAPI="5"

PHP_EXT_NAME="dio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="docs/examples/tutorial.txt ThanksTo.txt KnownIssues.txt"

USE_PHP="php5-6 php5-5 php5-4"

MY_PV=${PV/_rc/RC}
S="${WORKDIR}/${PN/pecl-/}-${MY_PV}"
inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Direct I/O functions for PHP"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

src_configure() {
	my_conf="--enable-dio --enable-shared"

	php-ext-source-r2_src_configure
}

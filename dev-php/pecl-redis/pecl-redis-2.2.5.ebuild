# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-redis/pecl-redis-2.2.5.ebuild,v 1.1 2014/09/29 19:32:13 grknight Exp $

EAPI="5"

PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

DOCS="README ChangeLog"

inherit php-ext-pecl-r2

KEYWORDS="~amd64"

DESCRIPTION="This extension provides an API for communicating with Redis servers"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="igbinary"

DEPEND="igbinary? ( dev-php/igbinary )"
RDEPEND="$DEPEND"

src_configure() {
	my_conf="--enable-redis
		$(use_enable igbinary redis-igbinary)"

	php-ext-source-r2_src_configure
}

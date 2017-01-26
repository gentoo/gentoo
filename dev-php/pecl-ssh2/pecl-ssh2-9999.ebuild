# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="ssh2"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-0 php5-6"
EGIT_REPO_URI="https://git.php.net/repository/pecl/networking/ssh2.git"

inherit php-ext-source-r3 git-r3

USE_PHP="php7-0"

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""
KEYWORDS=""
DEPEND=">=net-libs/libssh2-1.2"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-ssh2:0[php_targets_php5-6] )"
HOMEPAGE="https://pecl.php.net/package/ssh2"
PHP_EXT_ECONF_ARGS=""

src_unpack() {
	git-r3_src_unpack
	php-ext-source-r3_src_unpack
}

src_prepare() {
	if use php_targets_php7-0 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

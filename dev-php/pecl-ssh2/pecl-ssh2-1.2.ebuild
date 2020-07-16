# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ssh2"

USE_PHP="php5-6 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

# https://pecl.php.net/get/ssh2-1.2.tgz isn't work for some weeks
SRC_URI="https://dev.gentoo.org/~whissi/dist/${PN}/${P}.tar.gz"

USE_PHP="php7-1 php7-2 php7-3 php7-4"

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""
KEYWORDS="~amd64 ~x86"
# Upstream notes say there are errors with gcrypt backend
DEPEND=">=net-libs/libssh2-1.2[-gcrypt]"
RDEPEND="${DEPEND}
	php_targets_php5-6? ( dev-php/pecl-ssh2:0[php_targets_php5-6] )"

src_prepare() {
	if use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

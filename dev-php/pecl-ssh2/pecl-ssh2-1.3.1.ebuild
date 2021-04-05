# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ssh2"

USE_PHP="php7-3 php7-4 php8-0"

inherit php-ext-pecl-r3

USE_PHP="php7-3 php7-4 php8-0"

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""
KEYWORDS="~amd64 ~x86"
# Upstream notes say there are errors with gcrypt backend
DEPEND=">=net-libs/libssh2-1.2[-gcrypt]"
RDEPEND="${DEPEND}"

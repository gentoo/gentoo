# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="ssh2"

USE_PHP="php8-2 php8-3 php8-4 php8-5"

inherit php-ext-pecl-r3

DESCRIPTION="PHP bindings for the libssh2 library"
HOMEPAGE="https://pecl.php.net/package/ssh2"
LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="~amd64 ~x86"
# Upstream notes say there are errors with gcrypt backend
DEPEND=">=net-libs/libssh2-1.2[-gcrypt]"
RDEPEND="${DEPEND}"

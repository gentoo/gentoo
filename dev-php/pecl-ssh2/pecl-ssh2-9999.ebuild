# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ssh2"

USE_PHP="php7-2 php7-3 php7-4"
EGIT_REPO_URI="https://git.php.net/repository/pecl/networking/ssh2.git"

inherit php-ext-source-r3 git-r3

DESCRIPTION="PHP bindings for the libssh2 library"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""
KEYWORDS=""
DEPEND=">=net-libs/libssh2-1.2"
RDEPEND="${DEPEND}"
HOMEPAGE="https://pecl.php.net/package/ssh2"

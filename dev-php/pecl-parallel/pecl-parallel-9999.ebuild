# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="parallel"
USE_PHP="php8-0 php8-1"
PHP_EXT_NEEDED_USE="threads"
PHP_EXT_ECONF_ARGS=()

inherit php-ext-source-r3 git-r3

DESCRIPTION="A succint parallel concurrency API for PHP"
HOMEPAGE="https://pecl.php.net/package/parallel"
EGIT_REPO_URI="https://github.com/krakjoe/parallel.git"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS=""
IUSE="doc"

src_unpack() {
	git-r3_src_unpack

	# create the default modules directory to be able
	# to use the php-ext-source-r3 eclass to configure/build
	ln -s src "${S}/modules" || die
}

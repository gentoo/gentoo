# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_S="${S}/extension"
PHP_EXT_ECONF_ARGS=""
USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-pecl-r3

DESCRIPTION="A Hierarchical Profiler for PHP"
HOMEPAGE="https://pecl.php.net/package/xhprof"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

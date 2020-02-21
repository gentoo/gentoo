# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_S="${S}/extension"
PHP_EXT_ECONF_ARGS=""
USE_PHP="php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://pecl.php.net/package/xhprof"
DESCRIPTION="A Hierarchical Profiler for PHP"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

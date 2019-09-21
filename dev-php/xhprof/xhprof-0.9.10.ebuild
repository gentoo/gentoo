# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PV="dab44f76da5c8a0d4f1339f7d2ea2bc42408e8e9"
PHP_EXT_S="${WORKDIR}/${PN}-${MY_PV}/extension"
PHP_EXT_ECONF_ARGS=""
USE_PHP="php7-2 php7-3"

inherit php-ext-pecl-r3

SRC_URI="https://github.com/phacility/xhprof/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://pecl.php.net/package/xhprof"
DESCRIPTION="A Hierarchical Profiler for PHP"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

S="${WORKDIR}"

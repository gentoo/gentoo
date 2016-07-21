# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PV="ff8b3892d0cfc53e744631ff5c6b34f13421edce"
PHP_EXT_S="${WORKDIR}/${PN}-${MY_PV}/extension"

USE_PHP="php5-5 php5-6"

inherit php-ext-pecl-r2

SRC_URI="https://github.com/phacility/xhprof/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"

HOMEPAGE="http://pecl.php.net/package/xhprof"
DESCRIPTION="A Hierarchical Profiler for PHP"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

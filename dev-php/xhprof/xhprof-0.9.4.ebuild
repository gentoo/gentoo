# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xhprof/xhprof-0.9.4.ebuild,v 1.1 2014/10/01 00:44:13 grknight Exp $

EAPI="5"

PHP_EXT_S="${WORKDIR}/${P}/extension"

USE_PHP="php5-4 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

HOMEPAGE="http://pecl.php.net/package/xhprof"
DESCRIPTION="A Hierarchical Profiler for PHP"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

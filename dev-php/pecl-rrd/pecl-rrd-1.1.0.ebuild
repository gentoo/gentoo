# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-rrd/pecl-rrd-1.1.0.ebuild,v 1.2 2014/07/15 14:49:41 jer Exp $

EAPI=5

USE_PHP="php5-4 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"

SLOT="0"

DEPEND=">=net-analyzer/rrdtool-1.4.5-r1[graph]"
RDEPEND="${DEPEND}"

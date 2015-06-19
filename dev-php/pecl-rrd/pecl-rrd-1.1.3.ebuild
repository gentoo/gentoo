# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-rrd/pecl-rrd-1.1.3.ebuild,v 1.1 2014/09/30 23:15:52 grknight Exp $

EAPI=5

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"

SLOT="0"

DEPEND=">=net-analyzer/rrdtool-1.4.5-r1[graph]"
RDEPEND="${DEPEND}"

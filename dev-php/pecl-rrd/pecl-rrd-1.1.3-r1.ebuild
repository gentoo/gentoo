# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_PHP="php5-6"

inherit php-ext-pecl-r3

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-analyzer/rrdtool[graph]"
RDEPEND="${DEPEND}"

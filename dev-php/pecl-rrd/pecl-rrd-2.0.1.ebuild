# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Define 5.6 here to have the {,REQUIRED_}USE generated
USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r2

# But we really only build 7.0
USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"

SLOT="7"

DEPEND=">=net-analyzer/rrdtool-1.4.5-r1[graph]"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0 )"

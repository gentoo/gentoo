# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Define 5.6 here to have the {,REQUIRED_}USE generated
USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3

# But we really only build 7.0
USE_PHP="php7-0"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"
SLOT="7"
KEYWORDS="~amd64 ~x86"

DEPEND="net-analyzer/rrdtool[graph]"
RDEPEND="${DEPEND} php_targets_php5-6? ( ${CATEGORY}/${PN}:0 )"

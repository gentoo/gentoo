# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="DataStax PHP Driver for Apache Cassandra"
HOMEPAGE="https://github.com/datastax/php-driver"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-db/cpp-driver-2.4.3"
RDEPEND="${DEPEND}"

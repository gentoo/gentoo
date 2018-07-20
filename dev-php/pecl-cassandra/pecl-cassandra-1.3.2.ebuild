# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="DataStax PHP Driver for Apache Cassandra"
HOMEPAGE="https://github.com/datastax/php-driver"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-db/cpp-driver-2.7.0"
RDEPEND="${DEPEND}"

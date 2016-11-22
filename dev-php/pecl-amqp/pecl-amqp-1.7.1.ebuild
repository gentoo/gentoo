# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_PHP="php7-0 php5-6 php5-5"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP Bindings for AMQP 0-9-1 compatible brokers"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=">=net-libs/rabbitmq-c-0.5.2"
RDEPEND="${DEPEND}"

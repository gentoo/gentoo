# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-amqp/pecl-amqp-1.4.0.ebuild,v 1.1 2014/09/30 15:22:20 grknight Exp $

EAPI=5

USE_PHP="php5-6 php5-4 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP Bindings for AMQP 0-9-1 compatible brokers"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=">=net-libs/rabbitmq-c-0.4.1"
RDEPEND="${DEPEND}"

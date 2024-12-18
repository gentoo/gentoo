# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_PHP="php8-2 php8-3"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP Bindings for AMQP 0-9-1 compatible brokers"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests require running rabbitmq-server on localhost which requires epmd
# which only accepts /var/run/epmd.pid as pidfile.
RESTRICT="test"

RDEPEND=">=net-libs/rabbitmq-c-0.13.0:=[ssl(-)]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

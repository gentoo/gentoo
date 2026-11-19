# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="rdkafka"
USE_PHP="php7-4 php8-0 php8-1"
DOCS=( README.md CREDITS )

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Kafka"
HOMEPAGE="https://github.com/arnaud-lb/php-rdkafka"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/librdkafka"

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		# Some tests will be skipped (such that require a running Kafka instance).
		make test
	done
}

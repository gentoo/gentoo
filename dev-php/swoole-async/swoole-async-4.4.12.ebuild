# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="swoole_async"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_SAPIS="cli"
DOCS=( README.md )

USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

SRC_URI="https://github.com/swoole/ext-async/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ext-async-${PV}"
PHP_EXT_S="${S}"

HOMEPAGE="https://www.swoole.co.uk"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="An extension of Swoole, including the async callback style API"
LICENSE="Apache-2.0"
SLOT="0"
# Tests will require pre-configured endpoint
RESTRICT="test"

DEPEND=">=dev-php/swoole-4.3"

RDEPEND="${DEPEND}"

IUSE="debug"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-swoole_async
		$(use_enable debug)
	)

	php-ext-source-r3_src_configure
}

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		[[ -f tests/template.phpt ]] && rm tests/template.phpt
		SKIP_ONLINE_TESTS="yes" NO_INTERACTION="yes" emake test
	done
}

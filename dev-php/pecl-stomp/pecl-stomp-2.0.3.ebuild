# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_PHP="php8-0 php8-1 php8-2"
PHP_EXT_NAME="stomp"
PHP_EXT_NEEDED_USE="ssl(-)?"
DOCS=( CREDITS doc/classes.php doc/functions.php )

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension to communicate with Stomp message brokers"
LICENSE="PHP-3.01"
SLOT="7"
IUSE="examples ssl test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-stomp
		--with-openssl-dir=$(usex ssl yes no)
	)
	php-ext-source-r3_src_configure
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

USE_PHP="php5-4 php5-5 php5-6"
PHP_EXT_NAME="stomp"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CREDITS EXPERIMENTAL README"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension to communicate with any Stomp compliant Message Brokers"
LICENSE="PHP-3"
SLOT="0"
IUSE="+ssl"

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[ssl?] )"
done

DEPEND="${DEPEND}
	${PHPUSEDEPEND}
"

RDEPEND="${DEPEND}"

src_compile() {
	my_conf="--enable-stomp
		$(use_with ssl openssl-dir=/usr)"
	php-ext-pecl-r2_src_compile
}

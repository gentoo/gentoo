# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-syck/pecl-syck-0.9.3-r4.ebuild,v 1.1 2015/04/29 01:47:10 grknight Exp $

EAPI=5

PHP_EXT_NAME="syck"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CHANGELOG TODO"

USE_PHP="php5-6 php5-5 php5-4"
inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP bindings for Syck - reads and writes YAML with it"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[hash] )"
done

DEPEND="dev-libs/syck
	${PHPUSEDEPEND}"
RDEPEND="${DEPEND}"

src_prepare() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		epatch "${FILESDIR}"/fix-php-5-4-support.patch
	done
	php-ext-source-r2_src_prepare
}

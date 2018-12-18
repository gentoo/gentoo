# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/_beta/b}"
PHP_EXT_PECL_FILENAME="yaml-${MY_PV}.tgz"
PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS README )

USE_PHP="php7-0 php7-1 php7-2 php7-3 php5-6"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

S="${WORKDIR}/yaml-${MY_PV}"
PHP_EXT_S="${S}"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/libyaml-0.1.0"
RDEPEND="${DEPEND}"
PDEPEND="
	php_targets_php7-0? ( dev-php/pecl-yaml:7[php_targets_php7-0] )
	php_targets_php7-1? ( dev-php/pecl-yaml:7[php_targets_php7-1] )
	php_targets_php7-2? ( dev-php/pecl-yaml:7[php_targets_php7-2] )
	php_targets_php7-3? ( dev-php/pecl-yaml:7[php_targets_php7-3] )
"
PHP_EXT_ECONF_ARGS=""

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		default_src_prepare
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install
	fi
}

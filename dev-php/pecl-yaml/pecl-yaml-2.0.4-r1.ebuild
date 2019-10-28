# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_rc/RC}"
USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"

LICENSE="MIT"
SLOT="7"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libyaml"
RDEPEND="${DEPEND}"

S="${WORKDIR}/yaml-${MY_PV}"

PHP_EXT_ECONF_ARGS=""
PHP_EXT_PECL_FILENAME="yaml-${MY_PV}.tgz"
PHP_EXT_INI="yes"
PHP_EXT_NAME="yaml"
PHP_EXT_S="${S}"
PHP_EXT_ZENDEXT="no"

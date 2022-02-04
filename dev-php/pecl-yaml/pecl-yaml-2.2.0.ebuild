# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="yaml-${MY_PV}.tgz"
PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS README )

USE_PHP="php7-2 php7-3 php7-4 php8-0"

inherit php-ext-pecl-r3

S="${WORKDIR}/yaml-${MY_PV}"
PHP_EXT_S="${S}"

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"
LICENSE="MIT"
SLOT="7"
IUSE=""

DEPEND=">=dev-libs/libyaml-0.1.0"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=()

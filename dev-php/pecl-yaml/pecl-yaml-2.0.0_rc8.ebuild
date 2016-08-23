# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PV="${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="yaml-${MY_PV}.tgz"
PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS README )

USE_PHP="php7-0 php5-6"

inherit php-ext-pecl-r3

S="${WORKDIR}/yaml-${MY_PV}"
PHP_EXT_S="${S}"
USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"
LICENSE="MIT"
SLOT="7"
IUSE=""

DEPEND=">=dev-libs/libyaml-0.1.0"
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-yaml:0[php_targets_php5-6] )"
PHP_EXT_ECONF_ARGS=""

src_prepare() {
        if use php_targets_php7-0 ; then
                php-ext-source-r3_src_prepare
        else
                default_src_prepare
        fi
}


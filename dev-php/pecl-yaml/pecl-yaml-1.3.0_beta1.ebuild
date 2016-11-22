# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PV="${PV/_beta/b}"
PHP_EXT_PECL_FILENAME="yaml-${MY_PV}.tgz"
PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS README )

USE_PHP="php5-5 php5-6"

inherit php-ext-pecl-r3

S="${WORKDIR}/yaml-${MY_PV}"
PHP_EXT_S="${S}"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/libyaml-0.1.0"
RDEPEND="${DEPEND}"
PHP_EXT_ECONF_ARGS=""

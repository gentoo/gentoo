# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DOCS=( TODO )

USE_PHP="php5-6"

PHP_EXT_S="${WORKDIR}/Cairo-${PV}"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Cairo bindings for PHP"
LICENSE="PHP-3.01"
SLOT="0"

DEPEND=">=x11-libs/cairo-1.4[svg]"
RDEPEND="${DEPEND}"

IUSE=""

S="${PHP_EXT_S}"

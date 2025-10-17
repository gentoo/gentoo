# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_ECONF_ARGS=( --enable-${PN} )
PHP_EXT_INI="yes"
PHP_EXT_NAME="${PN}"
PHP_EXT_ZENDEXT="no"
USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-source-r3

GH_COMMIT="64178ef6401e039ca515cd00df675779ec407e7f"

DESCRIPTION="A fast drop-in replacement for the standard PHP serialize"
HOMEPAGE="https://github.com/igbinary/igbinary"
SRC_URI="https://github.com/${PN}/${PN}/archive/${GH_COMMIT}.tar.gz -> ${PN}_${GH_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${GH_COMMIT}"
PHP_EXT_S="${S}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

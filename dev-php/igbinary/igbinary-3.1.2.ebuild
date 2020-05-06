# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PHP_EXT_NAME="${PN}"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( CREDITS NEWS README.md )
PHP_EXT_ECONF_ARGS=( --enable-${PN} )

USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-source-r3

KEYWORDS="amd64 ~arm ~arm64 ~x86"

DESCRIPTION="A fast drop-in replacement for the standard PHP serialize"
HOMEPAGE="https://github.com/igbinary/igbinary"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
#IUSE=""

#DEPEND=""
#RDEPEND=""

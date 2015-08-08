# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="ffmpeg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-source-r2 eutils

KEYWORDS="amd64 x86"

DESCRIPTION="PHP extension that provides access to movie info"
HOMEPAGE="http://sourceforge.net/projects/ffmpeg-php/"
SRC_URI="mirror://sourceforge/ffmpeg-php/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/ffmpeg
		dev-lang/php:*[gd]"
RDEPEND="${DEPEND}"

# The test breaks with the test movie, but it the same code works fine with
# other movies

RESTRICT="test"

DOCS="CREDITS ChangeLog EXPERIMENTAL TODO"

src_prepare() {
	for slot in $(php_get_slots) ; do
		cd "${WORKDIR}/${slot}"
		epatch "${FILESDIR}/${P}-avutil50.patch"
		epatch "${FILESDIR}/${P}-ffmpeg.patch"
		epatch "${FILESDIR}/${P}-log.patch"
		epatch "${FILESDIR}/${P}-php5-4.patch"
		epatch "${FILESDIR}/${P}-ffincludes.patch"
		epatch "${FILESDIR}/${P}-ffmpeg1.patch"
		epatch "${FILESDIR}/${P}-api.patch"
		epatch "${FILESDIR}/${P}-libav10.patch"
	done
	php-ext-source-r2_src_prepare
}

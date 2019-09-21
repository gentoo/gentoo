# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6"

inherit php-ext-pecl-r3

DESCRIPTION="An interface to libharu, a PDF generator"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libharu[png(+),zlib(+)]"
RDEPEND="${DEPEND}"

src_configure() {
	# config.m4 is broken checking paths, so we need to override it
	local PHP_EXT_ECONF_ARGS=(
		--with-png-dir=/usr
		--with-zlib-dir=/usr
	)

	php-ext-source-r3_src_configure
}

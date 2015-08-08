# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php5-4 php5-5 php5-6"

inherit php-ext-pecl-r2

DESCRIPTION="An interface to libharu, a PDF generator"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="png zlib"

DEPEND="media-libs/libharu[png?,zlib?]"
RDEPEND="${DEPEND}"

src_configure() {
	# config.m4 is broken checking paths, so we need to override it
	my_conf=""
	use png && my_conf+=" --with-png-dir=/usr"
	use zlib && my_conf+=" --with-zlib-dir=/usr"

	php-ext-source-r2_src_configure
}

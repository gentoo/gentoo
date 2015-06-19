# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-haru/pecl-haru-1.0.4.ebuild,v 1.1 2013/12/09 21:34:18 mabi Exp $

EAPI=5

USE_PHP="php5-4 php5-5"

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

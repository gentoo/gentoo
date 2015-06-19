# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-imagick/pecl-imagick-3.1.2.ebuild,v 1.4 2015/01/04 08:10:03 ago Exp $

EAPI=5

DOCS="TODO"

MY_PV="${PV/rc/RC}"

USE_PHP="php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="amd64 x86"

DESCRIPTION="PHP wrapper for the ImageMagick library"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples"

DEPEND=">=media-gfx/imagemagick-6.2.4"
RDEPEND="${DEPEND}"

my_conf="--with-imagick=/usr"

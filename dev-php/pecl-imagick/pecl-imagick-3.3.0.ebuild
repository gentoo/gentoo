# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php5-6 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP wrapper for the ImageMagick library"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples test"

# imagemagick[-openmp] is needed wrt bug 547922 and upstream
# https://github.com/mkoppanen/imagick#openmp
RDEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]
	<media-gfx/imagemagick-7.0"
DEPEND="${RDEPEND}
	test? ( >=media-gfx/imagemagick-6.2.4:=[jpeg,png] )"

my_conf="--with-imagick=${EPREFIX}/usr"

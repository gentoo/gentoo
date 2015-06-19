# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-imagick/pecl-imagick-3.1.2-r1.ebuild,v 1.1 2015/04/29 00:29:03 grknight Exp $

EAPI=5

DOCS="TODO"

MY_PV="${PV/rc/RC}"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP wrapper for the ImageMagick library"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples"

# -openmp needed wrt bug 547922 and upstream https://github.com/mkoppanen/imagick#openmp
DEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]"
RDEPEND="${DEPEND}"

my_conf="--with-imagick=/usr"

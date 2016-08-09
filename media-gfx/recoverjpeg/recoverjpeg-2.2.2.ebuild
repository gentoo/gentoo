# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Recover JPEG pictures from a possibly corrupted disk image"
HOMEPAGE="http://www.rfc1149.net/devel/recoverjpeg.html"
SRC_URI="http://www.rfc1149.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-gfx/exif
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick-compat] )"
RDEPEND="${DEPEND}"

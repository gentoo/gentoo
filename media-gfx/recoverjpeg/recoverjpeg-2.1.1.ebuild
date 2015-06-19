# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/recoverjpeg/recoverjpeg-2.1.1.ebuild,v 1.2 2013/05/11 21:53:12 xmw Exp $

EAPI=4

inherit base

DESCRIPTION="Recover JPEG pictures from a possibly corrupted disk image"
HOMEPAGE="http://www.rfc1149.net/devel/recoverjpeg.html"
SRC_URI="http://www.rfc1149.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-gfx/exif
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog )

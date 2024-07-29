# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Recover JPEG pictures from a possibly corrupted disk image"
HOMEPAGE="https://rfc1149.net/devel/recoverjpeg.html"
SRC_URI="https://rfc1149.net/download/${PN}/${P}.tar.gz"

KEYWORDS="amd64 x86"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="media-gfx/exif
	virtual/imagemagick-tools"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog )

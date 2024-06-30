# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Recover JPEG pictures from a possibly corrupted disk image"
HOMEPAGE="https://rfc1149.net/devel/recoverjpeg.html
	https://github.com/samueltardieu/recoverjpeg"
SRC_URI="https://rfc1149.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-gfx/exif
	virtual/imagemagick-tools"
RDEPEND="${DEPEND}"

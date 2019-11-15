# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A portable C library for reading and writing BSB format image files"
HOMEPAGE="http://libbsb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libpng
	media-libs/tiff"
RDEPEND="${DEPEND}"

# "make check" in 0.0.7 fails with newer tiff versions (4.0.0) altough the
# tools work perfectly, so restrict test until this is fixed upstream
RESTRICT="test"

DOCS=( README AUTHORS )

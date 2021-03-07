# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Utilities for visualization and conversion of HDF5 files"
HOMEPAGE="http://ab-initio.mit.edu/h5utils/"
SRC_URI="http://ab-initio.mit.edu/h5utils/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="hdf octave"

DEPEND="
	media-libs/libpng:0=
	sci-libs/hdf5:0=
	sys-libs/zlib:0=
	hdf? (
		sci-libs/hdf:0=
		virtual/jpeg:0
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-automagic.patch
	"${FILESDIR}"/${P}-png15.patch
)

src_configure() {
	local myeconfargs=(
		--without-v5d
		$(use_with octave)
		$(use_with hdf)
		)
	autotools-utils_src_configure
}

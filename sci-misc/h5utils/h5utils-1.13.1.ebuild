# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utilities for visualization and conversion of HDF5 files"
HOMEPAGE="https://github.com/NanoComp/h5utils"
SRC_URI="https://github.com/NanoComp/h5utils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="hdf octave"

DEPEND="
	media-libs/libpng:0=
	sci-libs/hdf5:0=
	sys-libs/zlib
	hdf? (
		sci-libs/hdf:0=
		virtual/jpeg:0
	)"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-automagic.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--without-v5d \
		$(use_with octave) \
		$(use_with hdf)
}

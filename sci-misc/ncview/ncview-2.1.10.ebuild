# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="X-based viewer for netCDF files"
HOMEPAGE="https://cirrus.ucsd.edu/ncview/"
SRC_URI="https://cirrus.ucsd.edu/~pierce/ncview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libpng:0=
	sci-libs/netcdf[hdf5]
	sci-libs/udunits
	x11-libs/libXaw
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	doman data/ncview.1

	insinto /usr/share/X11/app-defaults
	newins Ncview-appdefaults Ncview

	insinto /usr/share/ncview
	doins *.ncmap

	make_desktop_entry ncview
}

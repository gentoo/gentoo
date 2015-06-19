# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/ncview/ncview-2.1.2.ebuild,v 1.1 2013/01/15 17:48:13 bicatali Exp $

EAPI=4

inherit eutils

DESCRIPTION="X-based viewer for netCDF files"
HOMEPAGE="http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
SRC_URI="ftp://cirrus.ucsd.edu/pub/ncview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	media-libs/libpng
	>=sci-libs/netcdf-4.1[hdf5]
	x11-libs/libXaw
	sci-libs/udunits"
RDEPEND="${DEPEND}"

src_install() {
	default
	doman data/${PN}.1
	insinto /usr/share/X11/app-defaults
	newins Ncview-appdefaults Ncview
	insinto /usr/share/${PN}
	doins *.ncmap
	make_desktop_entry ${PN}
}

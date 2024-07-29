# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools for reading and writing Data Matrix barcodes"
HOMEPAGE="https://github.com/dmtx/dmtx-utils"
SRC_URI="https://github.com/dmtx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# requires libdmtx-0.7.5 due to DmtxPropFnc1
RDEPEND="
	>=media-gfx/imagemagick-6.2.4:=
	>=media-libs/libdmtx-0.7.5
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	eautoreconf
}

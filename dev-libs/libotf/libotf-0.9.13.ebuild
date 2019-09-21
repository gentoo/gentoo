# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Library for handling OpenType fonts (OTF)"
HOMEPAGE="http://www.nongnu.org/m17n/"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs X"

RDEPEND=">=media-libs/freetype-2.4.9
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libICE
		x11-libs/libXmu
	)"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	export ac_cv_header_X11_Xaw_Command_h=$(usex X)
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}

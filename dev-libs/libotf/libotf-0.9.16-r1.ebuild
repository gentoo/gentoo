# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for handling OpenType fonts (OTF)"
HOMEPAGE="https://www.nongnu.org/m17n/"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
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
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.13-build.patch
	"${FILESDIR}"/${PN}-0.9.16-freetype_pkgconfig.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export ac_cv_header_X11_Xaw_Command_h=$(usex X)
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library for manipulating MacOS X .icns icon format"
HOMEPAGE="https://sourceforge.net/projects/icns/"
SRC_URI="mirror://sourceforge/icns/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	media-libs/libpng:0=
	media-libs/openjpeg:2="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.1-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.8.1-support-libopenjp2.patch
	"${FILESDIR}"/${PN}-0.8.1-fix-gcc-warnings.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

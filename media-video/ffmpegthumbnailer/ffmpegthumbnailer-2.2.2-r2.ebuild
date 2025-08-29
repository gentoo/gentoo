# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer"
SRC_URI="https://github.com/dirkvdb/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
IUSE="gtk jpeg png test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( png jpeg )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=media-video/ffmpeg-2.7:0=
	gtk? ( dev-libs/glib:2 )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	png? ( media-libs/libpng:0= )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog README.md )

PATCHES=( "${FILESDIR}"/ffmpeg5-{1,2,3,4,5,6,7,8,9,10}.patch )

src_configure() {
	local mycmakeargs=(
		-DENABLE_GIO=$(usex gtk)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_THUMBNAILER=ON
		-DHAVE_JPEG=$(usex jpeg)
		-DHAVE_PNG=$(usex png)
	)
	cmake_src_configure
}

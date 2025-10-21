# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer/"
SRC_URI="
	https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk +jpeg +png test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( png jpeg )"

RDEPEND="
	>=media-video/ffmpeg-6.1:=
	gtk? ( dev-libs/glib:2 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ffmpeg8.patch
)

CMAKE_QA_COMPAT_SKIP=1

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package png PNG)
		-DENABLE_GIO=$(usex gtk)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_THUMBNAILER=ON
	)

	cmake_src_configure
}

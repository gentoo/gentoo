# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="oneAPI Video Processing Library CPU implementation"
HOMEPAGE="https://github.com/oneapi-src/oneVPL-cpu"
SRC_URI="https://github.com/oneapi-src/oneVPL-cpu/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT x264? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="openh264 test +x264"
REQUIRED_USE="^^ ( openh264 x264 )"
# RESTRICT="!test? ( test )"
# Tests fail
RESTRICT="test"

BDEPEND="virtual/pkgconfig"
DEPEND="
	media-libs/dav1d
	media-libs/libvpl
	media-libs/svt-av1
	media-libs/svt-hevc
	media-video/ffmpeg
	x264? ( media-libs/x264 )
	openh264? ( media-libs/openh264 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2022.2.5-use-system-libs.patch"
	"${FILESDIR}/${PN}-2022.2.5-respect-user-flags.patch"
)

src_configure() {
	# Use system libraries
	export VPL_BUILD_DEPENDENCIES="${ESYSROOT}/usr"
	local mycmakeargs=(
		-DBUILD_OPENH264="$(usex openh264)"
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_GPL_X264="$(usex x264)"
		# Use FHS instead
		-DUSE_ONEAPI_INSTALL_LAYOUT=NO
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# Remove these license files
	rm -r "${ED}/usr/share/oneVPL-cpu/licensing" || die
}

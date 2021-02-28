# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Streaming audio processing library"
HOMEPAGE="https://github.com/andrewrk/libgroove"
SRC_URI="https://github.com/andrewrk/libgroove/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~amd64"
IUSE="+chromaprint +loudness +sound"

DEPEND="
	media-video/ffmpeg:=
	chromaprint? ( media-libs/chromaprint:= )
	loudness? ( media-libs/libebur128:=[speex(+)] )
	sound? ( media-libs/libsdl2[sound] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}_cflags.patch"
	"${FILESDIR}/${P}_sdl2_include_dir.patch"
	"${FILESDIR}/${P}_ffmpeg4.patch"
	"${FILESDIR}/${P}_GNUInstallDirs.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDISABLE_FINGERPRINTER=$(usex !chromaprint)
		-DDISABLE_LOUDNESS=$(usex !loudness)
		-DDISABLE_PLAYER=$(usex !sound)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm "${ED}"/usr/$(get_libdir)/*.a || die "failed to remove static libs"
}

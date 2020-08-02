# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Streaming audio processing library."
HOMEPAGE="https://github.com/andrewrk/libgroove"
SRC_URI="https://github.com/andrewrk/libgroove/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~amd64"
IUSE="+chromaprint +loudness +sound static-libs"

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
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use static-libs ; then
		rm "${ED%/}"/usr/$(get_libdir)/*.a || die "failed to remove static libs"
	fi
}

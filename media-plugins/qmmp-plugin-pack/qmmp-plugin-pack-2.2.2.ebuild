# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="Set of extra plugins for Qmmp"
HOMEPAGE="https://qmmp.ylsoftware.com/"
SRC_URI="https://qmmp.ylsoftware.com/files/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ffmpeg +libsamplerate modplug"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/taglib:=
	=media-sound/qmmp-$(ver_cut 1-2)*
	ffmpeg? ( media-video/ffmpeg:= )
	libsamplerate? ( media-libs/libsamplerate )
	modplug? ( media-libs/libmodplug )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		# enabled by default as taglib is already required by qmmp
		-DUSE_FFAP=ON
		-DUSE_FFVIDEO=$(usex ffmpeg)
		-DUSE_MODPLUG=$(usex modplug)
		-DUSE_SRC=$(usex libsamplerate)
	)
	cmake_src_configure
}

pkg_postinst() {
	optfeature "audio playback from YouTube" net-misc/yt-dlp
}

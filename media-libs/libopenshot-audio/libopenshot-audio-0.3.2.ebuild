# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for audio editing and playback used by OpenShot"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/8"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="media-libs/alsa-lib
	media-libs/freetype
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_AUDIO_DOCS=$(usex doc)
		-DAUTO_INSTALL_DOCS=$(usex doc)
	)
	cmake_src_configure
}

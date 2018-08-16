# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

DESCRIPTION="Cross-platform music production software"
HOMEPAGE="https://lmms.io"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/LMMS/lmms.git"
	inherit git-r3
else
	SRC_URI="https://github.com/LMMS/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P/_/-}"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="0"

IUSE="alsa debug fluidsynth jack libgig mp3 ogg portaudio pulseaudio sdl soundio stk vst"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.11
	sci-libs/fftw:3.0
	sys-libs/zlib
	>=x11-libs/fltk-1.3.0_rc3:1
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth )
	jack? ( virtual/jack )
	libgig? ( media-libs/libgig )
	mp3? ( media-sound/lame )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	portaudio? ( >=media-libs/portaudio-19_pre )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? (
		media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1
	)
	soundio? ( media-libs/libsoundio )
	stk? ( media-libs/stk )
	vst? ( virtual/wine )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/cmake-2.4.5
"
RDEPEND="${COMMON_DEPEND}
	media-libs/ladspa-cmt
	media-plugins/calf
	media-plugins/caps-plugins
	media-plugins/swh-plugins
	media-plugins/tap-plugins
"

DOCS=( README.md doc/AUTHORS )

src_configure() {
	local mycmakeargs+=(
		-DUSE_WERROR=FALSE
		-DWANT_SYSTEM_SR=TRUE
		-DWANT_CAPS=FALSE
		-DWANT_TAP=FALSE
		-DWANT_SWH=FALSE
		-DWANT_CMT=FALSE
		-DWANT_CALF=FALSE
		-DWANT_QT5=TRUE
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)
		-DWANT_ALSA=$(usex alsa)
		-DWANT_JACK=$(usex jack)
		-DWANT_GIG=$(usex libgig)
		-DWANT_MP3LAME=$(usex mp3)
		-DWANT_OGGVORBIS=$(usex ogg)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_SDL=$(usex sdl)
		-DWANT_SOUNDIO=$(usex soundio)
		-DWANT_STK=$(usex stk)
		-DWANT_VST=$(usex vst)
		-DWANT_SF2=$(usex fluidsynth)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

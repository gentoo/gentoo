# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Cross-platform music production software"
HOMEPAGE="https://lmms.io"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/LMMS/lmms.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/LMMS/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="0"

IUSE="alsa debug fluidsynth jack libgig ogg portaudio pulseaudio qt5 sdl soundio
	stk vst"

RDEPEND="qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4[accessibility]
	)
	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.11
	sci-libs/fftw:3.0
	sys-libs/zlib
	>=x11-libs/fltk-1.3.0_rc3:1
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth )
	jack? ( virtual/jack )
	libgig? ( media-libs/libgig )
	ogg? ( media-libs/libvorbis
		media-libs/libogg )
	portaudio? ( >=media-libs/portaudio-19_pre )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	soundio? ( media-libs/libsoundio )
	stk? ( media-libs/stk )
	vst? ( app-emulation/wine )"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	>=dev-util/cmake-2.4.5"
RDEPEND="${RDEPEND}
	media-plugins/swh-plugins
	media-plugins/caps-plugins
	media-plugins/tap-plugins
	media-plugins/calf
	media-libs/ladspa-cmt"

DOCS=(README.md doc/AUTHORS)

src_configure() {
	mycmakeargs+=(
		-DUSE_WERROR=FALSE
		-DWANT_SYSTEM_SR=TRUE
		-DWANT_CAPS=FALSE
		-DWANT_TAP=FALSE
		-DWANT_SWH=FALSE
		-DWANT_CMT=FALSE
		-DWANT_CALF=FALSE
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)
		-DWANT_ALSA=$(usex alsa)
		-DWANT_JACK=$(usex jack)
		-DWANT_GIG=$(usex libgig)
		-DWANT_OGGVORBIS=$(usex ogg)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_QT5=$(usex qt5)
		-DWANT_SDL=$(usex sdl)
		-DWANT_SOUNDIO=$(usex soundio)
		-DWANT_STK=$(usex stk)
		-DWANT_VST=$(usex vst)
		-DWANT_SF2=$(usex fluidsynth)
	)
	cmake-utils_src_configure
}

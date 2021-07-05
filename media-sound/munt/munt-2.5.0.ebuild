# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake xdg

DESCRIPTION="software synthesiser emulating pre-GM MIDI devices (Roland MT-32)"
HOMEPAGE="http://munt.sourceforge.net"
SRC_URI="mirror://sourceforge/munt/${PV}/${P}.tar.gz"

# library: GPL-2 and LGPL-2.1, qt frontend: GPL-3
LICENSE="LGPL-2.1+ GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio qt5"

DEPEND="
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio )
	)
	|| ( media-libs/soxr media-libs/libsamplerate )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s#share/doc/${PN}#share/doc/${PF}#" \
		-e "s#COPYING\(.LESSER\)\?.txt ##g" \
		-i */CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-Dlibmt32emu_SHARED=yes
		-Dmunt_WITH_MT32EMU_SMF2WAV=yes
		-Dmunt_WITH_MT32EMU_QT=$(usex qt5)
	)
	if use qt5; then
		mycmakeargs+=(
			-Dmt32emu-qt_WITH_ALSA_MIDI_SEQUENCER=$(usex alsa)
			-Dmt32emu-qt_USE_PULSEAUDIO_DYNAMIC_LOADING=$(usex pulseaudio)
			-Dmt32emu-qt_WITH_QT5=ON
		)
	fi
	cmake_src_configure
}

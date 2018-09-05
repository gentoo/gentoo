# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit cmake-utils wxwidgets

MY_P="CubicSDR"
SRC_URI="https://github.com/cjcliffe/${MY_P}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}-${PV}"

DESCRIPTION="Cross-Platform and Open-Source Software Defined Radio Application"
HOMEPAGE="https://cubicsdr.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"

DEPEND="
	net-libs/liquid-dsp
	x11-libs/wxGTK:${WX_GTK_VER}[opengl]
	net-wireless/soapysdr
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DUSE_AUDIO_ALSA="$(usex alsa)"
		-DUSE_AUDIO_PULSE="$(usex pulseaudio)"
	)

	cmake-utils_src_configure
}

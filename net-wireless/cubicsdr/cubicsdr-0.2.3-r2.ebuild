# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cjcliffe/CubicSDR.git"
else
	MY_P="CubicSDR"
	SRC_URI="https://github.com/cjcliffe/${MY_P}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Cross-Platform and Open-Source Software Defined Radio Application"
HOMEPAGE="https://cubicsdr.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa pulseaudio"

RDEPEND="
	net-libs/liquid-dsp
	x11-libs/wxGTK:${WX_GTK_VER}[opengl]
	net-wireless/soapysdr
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DUSE_AUDIO_ALSA=$(usex alsa)
		-DUSE_AUDIO_PULSE=$(usex pulseaudio)
	)

	cmake_src_configure
}

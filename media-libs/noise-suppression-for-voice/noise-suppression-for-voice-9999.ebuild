# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A real-time noise suppression plugin for voice"
HOMEPAGE="https://github.com/werman/noise-suppression-for-voice"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/werman/noise-suppression-for-voice.git"
else
	SRC_URI="https://github.com/werman/noise-suppression-for-voice/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="+ladspa lv2 vst vst3"
REQUIRED_USE="|| ( ladspa lv2 vst vst3 )"

COMMON_DEPEND="
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXinerama
	x11-libs/libXrandr
"

DEPEND="
	lv2? ( ${COMMON_DEPEND} )
	vst? ( ${COMMON_DEPEND} )
	vst3? ( ${COMMON_DEPEND} )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_LADSPA_PLUGIN=$(usex ladspa ON OFF)
		-DBUILD_LV2_PLUGIN=$(usex lv2 ON OFF)
		-DBUILD_VST_PLUGIN=$(usex vst ON OFF)
		-DBUILD_VST3_PLUGIN=$(usex vst3 ON OFF)
		-DBUILD_AU_PLUGIN=OFF
		-DBUILD_AUV3_PLUGIN=OFF
	)
	cmake_src_configure
}

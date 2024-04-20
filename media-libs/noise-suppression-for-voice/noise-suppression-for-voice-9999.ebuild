# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A real-time noise suppression plugin for voice"
HOMEPAGE="https://github.com/werman/noise-suppression-for-voice"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/werman/noise-suppression-for-voice.git"
else
	SRC_URI="https://github.com/werman/noise-suppression-for-voice/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	PATCHES=(
		"${FILESDIR}/${P}-tests.patch"
	)
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="+ladspa lv2 vst vst3 test"
REQUIRED_USE="|| ( ladspa lv2 vst vst3 )"
RESTRICT="!test? ( test )"

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
	# Bug #925672
	# append-atomic-flags does not work for us in this case, as it can
	# only test for single integers of given sizes, meanwhile
	# noise-suppression-for-voice does std::atomic<RnNoiseStats>, where
	# RnNoiseStats is a struct with 4 uint32_t members.
	if test-flags-CCLD "-latomic" &>/dev/null; then
		append-flags -Wl,--push-state,--as-needed,-latomic,--pop-state
	fi

	local mycmakeargs=(
		-DBUILD_LADSPA_PLUGIN=$(usex ladspa ON OFF)
		-DBUILD_LV2_PLUGIN=$(usex lv2 ON OFF)
		-DBUILD_VST_PLUGIN=$(usex vst ON OFF)
		-DBUILD_VST3_PLUGIN=$(usex vst3 ON OFF)
		-DBUILD_TESTS=$(usex test ON OFF)
		-DBUILD_AU_PLUGIN=OFF
		-DBUILD_AUV3_PLUGIN=OFF
	)
	cmake_src_configure
}

src_test() {
	cp "${BUILD_DIR}/src/common/CTestTestfile.cmake" "${BUILD_DIR}/CTestTestfile.cmake" || die
	cmake_src_test
}

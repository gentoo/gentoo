# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="3D rendering module for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE=""

RDEPEND="
	=dev-qt/qtbase-${PV}*[concurrent,gui,network,opengl,vulkan,widgets]
	=dev-qt/qtdeclarative-${PV}*[widgets]
	=dev-qt/qtmultimedia-${PV}*
	=dev-qt/qtshadertools-${PV}*
	media-libs/assimp:=
"
DEPEND="${RDEPEND}
	dev-util/vulkan-headers
"

# No qtgamepad branching since 6.3.
src_configure() {
	local mycmakeargs=(
		-DQT_FEATURE_opengl=ON
		-DQT_FEATURE_qt3d_animation=ON
		-DQT_FEATURE_qt3d_extras=ON
		-DQT_FEATURE_qt3d_input=ON
		-DQT_FEATURE_qt3d_logic=ON
		-DQT_FEATURE_qt3d_render=ON
		-DQT_FEATURE_qt3d_rhi_renderer=ON
		-DQT_FEATURE_qt3d_system_assimp=ON
		-DQT_FEATURE_regularexpression=ON
		-DQT_FEATURE_system_zlib=ON
		-DQT_FEATURE_vulkan=ON
	)

	qt6-build_src_configure
}

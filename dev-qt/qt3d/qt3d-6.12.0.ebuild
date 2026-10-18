# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="3D rendering module for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	EGIT_SUBMODULES=() # skip qtquick3d-assimp
fi

IUSE="gles2-only qml vulkan"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[concurrent,gles2-only=,gui,network,opengl,vulkan=]
	~dev-qt/qtshadertools-${PV}:6
	media-libs/assimp:=
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.9.2-assimp6.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
		-DQT_FEATURE_qt3d_system_assimp=ON
	)

	qt6-build_src_configure
}

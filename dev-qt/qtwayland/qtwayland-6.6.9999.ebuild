# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~x86"
fi

IUSE="compositor qml vulkan"

RDEPEND="
	dev-libs/wayland
	~dev-qt/qtbase-${PV}:6[gui,opengl,vulkan=]
	media-libs/libglvnd
	x11-libs/libxkbcommon
	compositor? (
		qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="dev-util/wayland-scanner"

CMAKE_SKIP_TESTS=(
	# segfaults for not-looked-into reasons, but not considered
	# an issue given >=seatv5 exists since wayland-1.10 (2016)
	tst_seatv4
	# needs a compositor/opengl, skip the extra trouble
	tst_surface
	tst_xdgdecorationv1
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
		$(qt_feature compositor wayland_server)
	)

	qt6-build_src_configure
}

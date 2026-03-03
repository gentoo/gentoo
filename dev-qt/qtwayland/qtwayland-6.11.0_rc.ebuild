# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Toolbox for making Qt based Wayland compositors"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="gnome qml"

RDEPEND="
	dev-libs/wayland
	~dev-qt/qtbase-${PV}:6[gui,opengl,wayland]
	media-libs/libglvnd
	x11-libs/libxkbcommon
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
	gnome? (
		~dev-qt/qtbase-${PV}:6[dbus]
		~dev-qt/qtsvg-${PV}:6
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/wayland-scanner
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
		$(qt_feature gnome wayland_decoration_adwaita)
	)

	qt6-build_src_configure
}

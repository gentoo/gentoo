# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

RDEPEND="
	dev-libs/wayland
	=dev-qt/qtbase-${PV}*:6[egl,gui,opengl]
	=dev-qt/qtdeclarative-${PV}*:6
	media-libs/libglvnd
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/wayland-scanner"

PATCHES=(
	"${FILESDIR}"/${P}-drag-drop-segfault.patch
)

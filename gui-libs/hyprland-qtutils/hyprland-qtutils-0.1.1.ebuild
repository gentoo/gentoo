# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland QT/qml utility apps"
HOMEPAGE="https://github.com/hyprwm/hyprland-qtutils"
SRC_URI="https://github.com/hyprwm/${PN}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"

KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	dev-qt/qtwayland:6
	gui-libs/hyprutils:=
	kde-frameworks/qqc2-desktop-style:6
"
DEPEND="${RDEPEND}"

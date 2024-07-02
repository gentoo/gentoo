# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
inherit cmake plasma.kde.org

DESCRIPTION="Wallpapers for the Plasma workspace"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	kde-frameworks/extra-cmake-modules:0
"

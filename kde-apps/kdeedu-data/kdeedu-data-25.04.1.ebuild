# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gear.kde.org xdg

DESCRIPTION="Shared icons, artwork and data files for educational applications"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

BDEPEND="
	dev-qt/qtbase:6
	>=kde-frameworks/extra-cmake-modules-6.0:0
"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gear.kde.org cmake

DESCRIPTION="Shared icons, artwork and data files for educational applications"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

BDEPEND="
	dev-qt/qtcore:5
	kde-frameworks/extra-cmake-modules:5
"

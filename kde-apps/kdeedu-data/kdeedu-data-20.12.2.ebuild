# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde.org cmake

DESCRIPTION="Shared icons, artwork and data files for educational applications"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/qtcore:5
	kde-frameworks/extra-cmake-modules:5
"

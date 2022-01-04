# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
inherit cmake kde.org

DESCRIPTION="Wallpapers for the Plasma workspace"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

BDEPEND="
	dev-qt/qtcore:5
	kde-frameworks/extra-cmake-modules:5
"

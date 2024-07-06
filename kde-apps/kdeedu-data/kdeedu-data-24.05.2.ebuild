# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gear.kde.org

DESCRIPTION="Shared icons, artwork and data files for educational applications"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

BDEPEND="
	dev-qt/qtbase:6
	>=kde-frameworks/extra-cmake-modules-6.0:0
"

src_prepare() {
	cmake_src_prepare

	# default in git master/>=24.08, no code change since 2023
	# this is a better fit since all revdeps are already KF6
	sed -e "/find_package.*ECM/s/5\.90/6.0/" -i CMakeLists.txt || die
}

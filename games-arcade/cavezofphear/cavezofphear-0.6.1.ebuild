# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A boulder dash / digger-like game for console using ncurses"
HOMEPAGE="https://github.com/AMDmi3/cavezofphear"
SRC_URI="https://github.com/AMDmi3/cavezofphear/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND=">=sys-libs/ncurses-5:0="
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/help2man"

PATCHES=(
	"${FILESDIR}"/${P}-gcc15.patch
)

src_configure() {
	local mycmakeargs=(
		-DSYSTEMWIDE=yes
	)

	cmake_src_configure
}

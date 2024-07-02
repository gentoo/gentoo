# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="https://bino3d.org/"
SRC_URI="https://bino3d.org/releases/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pandoc
"

src_compile() {
	local mycmakeargs=(
		# Unpackaged
		-DCMAKE_DISABLE_FIND_PACKAGE_QVR=ON
	)

	cmake_src_configure
}

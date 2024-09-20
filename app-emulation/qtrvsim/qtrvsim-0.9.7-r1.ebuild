# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="RISC-V CPU simulator for education"
HOMEPAGE="https://github.com/cvut/qtrvsim"
SRC_URI="https://github.com/cvut/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	virtual/libelf:=
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# Fails in 0.9.7, but not in master.
	cli_stalls
)

src_prepare() {
	cmake_src_prepare

	# ensure Qt6 build
	sed "/^ *find_package.*QT NAMES/s/Qt5 //" \
		-i CMakeLists.txt || die
}

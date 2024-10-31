# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="RISC-V CPU simulator for education"
HOMEPAGE="https://github.com/cvut/qtrvsim"
SRC_URI="https://github.com/cvut/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	virtual/libelf:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
	)
	cmake_src_configure
}

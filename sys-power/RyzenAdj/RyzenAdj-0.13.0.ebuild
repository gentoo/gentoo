# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The power management tool for mobile and desktop Ryzen APUs"
HOMEPAGE="https://github.com/FlyGoat/RyzenAdj"
SRC_URI="https://github.com/FlyGoat/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-apps/pciutils"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}

src_install() {
	dosbin "${BUILD_DIR}"/ryzenadj

	dolib.so "${BUILD_DIR}"/libryzenadj.so

	dodoc "${S}"/README.md
}

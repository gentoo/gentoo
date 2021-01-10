# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CMAKE_IN_SOURCE_BUILD="1"
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake

DESCRIPTION="Chinese tables for IBus-Table"
HOMEPAGE="https://github.com/definite/ibus-table-chinese"
SRC_URI="https://github.com/definite/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-i18n/ibus-table"
DEPEND="${RDEPEND}
	dev-util/cmake-fedora"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_FEDORA_TMP_DIR="${T}"
		-DDATA_DIR="${EPREFIX}"/usr/share
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=false
		-DPRJ_DOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake_src_configure
}

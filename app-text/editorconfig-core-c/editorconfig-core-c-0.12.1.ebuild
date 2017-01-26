# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="EditorConfig core library written in C"
HOMEPAGE="https://github.com/editorconfig/${PN}/"
SRC_URI="https://github.com/editorconfig/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli doc"
CDEPEND="dev-libs/libpcre:="
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	cli? ( !dev-python/editorconfig-core-py[cli] )"

src_prepare() {
	sed -e 's:OUTPUT_NAME editorconfig_static:OUTPUT_NAME editorconfig:' \
		-i src/lib/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()
	use doc && mycmakeargs+=(-DINSTALL_HTML_DOC=ON)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use cli || rm -rf "${ED}usr/bin"
}

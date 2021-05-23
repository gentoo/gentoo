# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Ultra-lightweight JavaScript engine for the Internet of Things"
HOMEPAGE="https://github.com/jerryscript-project/jerryscript"
SRC_URI="https://github.com/jerryscript-project/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	find . -name CMakeLists.txt -print0 | xargs -0 sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:" \
		-e "s:DESTINATION lib):DESTINATION $(get_libdir)):" \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STRIP=OFF
		-DJERRY_DEBUGGER=ON
		-DJERRY_ERROR_MESSAGES=ON
		-DJERRY_EXTERNAL_CONTEXT=ON
		-DJERRY_LINE_INFO=ON
		-DJERRY_LOGGING=ON
		-DJERRY_PARSER_DUMP_BYTE_CODE=ON
		-DJERRY_PARSER=ON
		-DJERRY_REGEXP_DUMP_BYTE_CODE=ON
		-DJERRY_SNAPSHOT_EXEC=ON
		-DJERRY_SNAPSHOT_SAVE=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

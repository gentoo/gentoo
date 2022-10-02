# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Ultralightweight JSON parser in ANSI C"
HOMEPAGE="https://github.com/DaveGamble/cJSON"
SRC_URI="https://github.com/DaveGamble/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare

	sed -i -e '/-Werror/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CJSON_TEST=$(usex test)
	)

	cmake_src_configure
}

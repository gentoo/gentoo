# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A header-only C++ library for printing colored messages to the terminal"
HOMEPAGE="https://github.com/ikalnytskyi/termcolor https://termcolor.readthedocs.io"
SRC_URI="https://github.com/ikalnytskyi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# It's just a visual test, nothing automated / no way to detect failure in an ebuild.
RESTRICT="!test? ( test ) test"

src_configure() {
	local mycmakeargs=(
		-DTERMCOLOR_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/test_termcolor || die
}

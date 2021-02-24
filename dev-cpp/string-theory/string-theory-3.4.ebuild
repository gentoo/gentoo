# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A flexible modern C++ library for string manipulation and storage"
HOMEPAGE="https://github.com/zrax/string_theory/"
SRC_URI="https://github.com/zrax/string_theory/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/string_theory-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	# Drop -Werror from bundled gtest
	# bug #766468
	sed -i -e "s/-Werror//" test/gtest-1.10.0/cmake/internal_utils.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DST_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/test" || die
	./st_gtests || die
}

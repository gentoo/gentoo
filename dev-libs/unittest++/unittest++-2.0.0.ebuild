# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN="unittest-cpp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A lightweight unit testing framework for C++"
HOMEPAGE="https://unittest-cpp.github.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake-utils_src_prepare

	# https://github.com/unittest-cpp/unittest-cpp/pull/163
	sed -i '/run unit tests as post build step/,/Running unit tests/d' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUTPP_INCLUDE_TESTS_IN_BUILD=$(usex test)
	)
	cmake-utils_src_configure
}

src_test() {
	"${BUILD_DIR}/TestUnitTest++" || die "Tests failed"
}

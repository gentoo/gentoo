# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo

DESCRIPTION="Cross-platform access library for Intel CSME HECI interface"
HOMEPAGE="https://github.com/intel/metee"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.0-system-gtest.patch
)

src_prepare() {
	cmake_src_prepare

	# Respect users CFLAGS
	sed -e 's/-D_FORTIFY_SOURCE=2 -O2//' -e 's/-Werror//' -i linux.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_SAMPLES="NO"
		-DBUILD_SHARED_LIBS="YES"
		-DBUILD_TEST="$(usex test)"
		-DCONSOLE_OUTPUT="NO"
	)

	cmake_src_configure
}

src_test() {
	local skip_tests=(
		MeTeeTESTInstance/MeTeeTEST.PROD_N_TestGetMeiKind/PCH
		MeTeePPTESTInstance/MeTeePPTEST.PROD_MKHI_MoveSemantics/PCH
	)

	# The format for disabling test1, test2, and test3 looks like:
	# -test1:test2:test3
	edo "${BUILD_DIR}"/tests/metee_test \
		--gtest_filter=-$(echo $(IFS=:; echo "${skip_tests[*]}"))
}

src_install() {
	cmake_src_install

	# Don't install test binary
	if use test ; then
		rm "${ED}"/usr/bin/metee_test || die
	fi
}

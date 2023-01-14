# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-any-r1

# yes, it needs SOURCE, not just installed one
# and no, 1.11.0 is not enough
GTEST_COMMIT="1b18723e874b256c1e39378c6774a90701d70f7a"
GTEST_FILE="gtest-${GTEST_COMMIT}.tar.gz"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> ${GTEST_FILE} )"

LICENSE="
	Apache-2.0
	test? ( BSD )
"
SLOT="0/${PV%%.*}"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	test? ( sys-libs/timezone-data )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-20211102.0-fix-cuda-nvcc-build.patch"
	"${FILESDIR}/${PN}-20211102.0-r2-cuda11.6-compile-fix.patch"
	"${FILESDIR}/${PN}-20211102.0-r2-loong.patch"
	"${FILESDIR}/${PN}-20211102.0-r2-gcc-13.patch"
)

src_prepare() {
	cmake_src_prepare

	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die

	if use test; then
		sed -i 's/-Werror//g' \
			"${WORKDIR}/googletest-${GTEST_COMMIT}"/googletest/cmake/internal_utils.cmake || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_LOCAL_GOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		-DCMAKE_CXX_STANDARD=17
		-DABSL_PROPAGATE_CXX_STD=TRUE
		$(usex test -DBUILD_TESTING=ON '') #intentional usex
	)
	cmake_src_configure
}

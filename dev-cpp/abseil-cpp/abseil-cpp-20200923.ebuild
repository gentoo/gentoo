# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake python-any-r1

# yes, it needs SOURCE, not just installed one
GTEST_COMMIT="fe4d5f10840c5f62b984364a4d41719f1bc079a2"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> gtest-${GTEST_COMMIT}.tar.gz"

LICENSE="
	Apache-2.0
	test? ( BSD )
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

RESTRICT="!test? ( test )"

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
	absl/copts/generate_copts.py || die
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_LOCAL_GOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		-DABSL_RUN_TESTS=$(usex test)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

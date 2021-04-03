# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-any-r1 toolchain-funcs

# yes, it needs SOURCE, not just installed one
GTEST_COMMIT="aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e"
GTEST_FILE="gtest-1.10.0_p20200702.tar.gz"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> ${GTEST_FILE}"

LICENSE="
	Apache-2.0
	test? ( BSD )
"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+cxx17 test"

DEPEND=""
RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	test? ( sys-libs/timezone-data )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-20200923-arm_no_crypto.patch"
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

	sed -i 's/-Werror//g' \
		"${WORKDIR}/googletest-${GTEST_COMMIT}"/googletest/cmake/internal_utils.cmake || die
}

src_configure() {
	if use arm || use arm64; then
		if [[ $($(tc-getCXX) ${CXXFLAGS} -E -P - <<<$'#if defined(__ARM_FEATURE_CRYPTO)\nHAVE_ARM_FEATURE_CRYPTO\n#endif') != *HAVE_ARM_FEATURE_CRYPTO* ]]; then
			append-cxxflags -DABSL_ARCH_ARM_NO_CRYPTO
		fi
	fi

	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_LOCAL_GOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		$(usex cxx17 -DCMAKE_CXX_STANDARD=17 '') # it has to be a useflag for some consumers
		$(usex test -DBUILD_TESTING=ON '') #intentional usex
	)
	cmake_src_configure
}

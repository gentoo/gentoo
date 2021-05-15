# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake flag-o-matic python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

# requires source of gtest and other libs
RESTRICT=test

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
}

src_configure() {
	if use arm || use arm64; then
		# bug #778926
		if [[ $($(tc-getCXX) ${CXXFLAGS} -E -P - <<<$'#if defined(__ARM_FEATURE_CRYPTO)\nHAVE_ARM_FEATURE_CRYPTO\n#endif') != *HAVE_ARM_FEATURE_CRYPTO* ]]; then
			append-cxxflags -DABSL_ARCH_ARM_NO_CRYPTO
		fi
	fi

	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DBUILD_SHARED_LIBS=TRUE
	)
	cmake_src_configure
}

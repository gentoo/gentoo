# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake flag-o-matic python-any-r1

DESCRIPTION="High-performance regular expression matching library"
SRC_URI="https://github.com/intel/hyperscan/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://www.hyperscan.io/ https://github.com/intel/hyperscan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_avx2 cpu_flags_x86_ssse3 static-libs"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/ragel
"

# We can't default this to on as it's against the expectation of
# how CPU_FLAGS_* work for users.
REQUIRED_USE="cpu_flags_x86_ssse3"

src_prepare() {
	# Respect user -O flags
	sed -i '/set(OPT_CX*_FLAG/d' CMakeLists.txt || die

	# upstream workaround
	append-cxxflags -Wno-redundant-move
	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	use cpu_flags_x86_ssse3 && append-flags -mssse3
	use cpu_flags_x86_avx2  && append-flags -mavx2

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_STATIC_AND_SHARED=$(usex static-libs ON OFF)
		-DFAT_RUNTIME=false
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/unit-hyperscan || die
}

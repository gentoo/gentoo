# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocrand"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocrand.tar.gz -> rocrand-${PV}.tar.gz
	benchmark? (
		https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/primbench.tar.gz
			-> primbench-${PV}.tar.gz
	)
"
S="${WORKDIR}/rocrand"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}"
DEPEND="${RDEPEND}
	dev-build/rocm-cmake
	test? ( dev-cpp/gtest )"
BDEPEND="dev-build/rocm-cmake"

src_prepare() {
	# do not install tests
	sed -e '/rocm_install(TARGETS .* COMPONENT tests)/d' \
		-e '/^rocm_install($/,/^)$/d' \
		-i test/CMakeLists.txt test/*/CMakeLists.txt || die

	# primbench comes from its own tarball
	if use benchmark; then
		sed -e "s:\${PROJECT_SOURCE_DIR}/\.\./\.\./shared/primbench:${WORKDIR}/primbench:" \
			-i benchmark/CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	export ROCM_PATH="${EPREFIX}/usr"

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/library"
	cmake_src_test -j1
}

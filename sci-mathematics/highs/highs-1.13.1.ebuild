# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern solver for linear, quadratic, and mixed-integer programs"
HOMEPAGE="https://highs.dev/
	https://github.com/ERGO-Code/HiGHS"
SRC_URI="https://github.com/ERGO-Code/HiGHS/releases/download/v${PV}/source-archive.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/HiGHS"
LICENSE="MIT"
SLOT="0/1"  # soname major
KEYWORDS="~amd64 ~riscv"

# USE=hipo was dropped in 1.13.0 because upstream began bundling
# sci-libs/{amd,metis} and has no plans to unbundle them.
IUSE="examples index64 test +threads zlib"

# The tests fail for me due to precision issues (gcc) and something
# worse (clang): https://github.com/ERGO-Code/HiGHS/issues/2690
RESTRICT="test"

# There are no external dependencies for a non-HiPO build. An old
# version of dev-cpp/catch (header only) is bundled for tests under
# extern/catch.hpp, but we don't use the tests.

src_prepare() {
	# Sometimes the .git directory makes it into the release tarballs
	# and cmake will waste time computing the latest commit.
	rm -rf .git || die

	# Just a precaution. These should only be used by the HiPO build,
	# and we disable it.
	rm -r extern/{amd,metis,rcm} || die

	# Remove docs for stuff we don't install
	rm -r docs/src/assets || die
	rm docs/src/interfaces/{csharp,fortran}.md || die

	cmake_src_prepare
}

src_configure() {
	# Without FAST_BUILD=ON, some options aren't even available.
	#
	# It would be easy to support USE=fortran with virtual/fortran, but
	# unless someone needs it, it's simpler to leave the fortran
	# interface disabled.
	#
	# The python interface can't be built at the same time as the C/C++
	# bits. In any case, we should probably package dev-python/highspy
	# separately since that's how people will look for it.
	local mycmakeargs=(
		-DALL_TESTS=$(usex test)
		-DBLA_PKGCONFIG_BLAS=cblas
		-DBUILD_CSHARP_EXAMPLE=OFF
		-DBUILD_CXX_EXAMPLE=$(usex examples)
		-DBUILD_CXX=ON
		-DBUILD_CXX_EXE=ON
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_DOTNET=OFF
		-DBUILD_TESTING=$(usex test)
		-DCSHARP=OFF
		-DCUPDLP_GPU=OFF
		-DCUPDLP_FIND_CUDA=OFF
		-DEMSCRIPTEN_HTML=OFF
		-DFAST_BUILD=ON
		-DFORTRAN=OFF
		-DHIGHS_COVERAGE=OFF
		-DHIGHS_NO_DEFAULT_THREADS=$(usex threads OFF ON)
		-DHIGHSINT64=$(usex index64)
		-DHIPO=OFF
		-DPYTHON_BUILD_SETUP=OFF
		-DUSE_DOTNET_STD_21=OFF
		-DZLIB=$(usex zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/share/doc/${PF}/LICENSE.txt" || die

	docinto manual
	dodoc -r docs/src/*

	if use examples; then
		docinto examples
		dodoc examples/*.{c,cpp,py}
	fi
}

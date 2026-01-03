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
IUSE="examples hipo index64 test +threads zlib"

# The tests fail for me due to precision issues (gcc) and something
# worse (clang): https://github.com/ERGO-Code/HiGHS/issues/2690
RESTRICT="test"

# An old version of dev-cpp/catch (header only) is bundled for tests
# under extern/catch.hpp.
RDEPEND="
	hipo? (
		sci-libs/metis
		virtual/cblas
	)
"
DEPEND="${RDEPEND}"

DOCS=(
	AUTHORS
	CITATION.cff
	CODE_OF_CONDUCT.md
	CONTRIBUTING.md
	FEATURES.md
	README.md
)

PATCHES=(
	"${FILESDIR}/highs-1.12.0-hipo-search-paths.patch"
)

src_prepare() {
	# Sometimes the .git directory makes it into the release tarballs
	# and cmake will waste time computing the latest commit.
	rm -rf .git || die

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
		-DHIPO=$(usex hipo)
		-DMETIS_ROOT="${EPREFIX}/usr"
		-DPYTHON_BUILD_SETUP=OFF
		-DUSE_DOTNET_STD_21=OFF
		-DZLIB=$(usex zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	docinto manual
	dodoc -r docs/src/*

	if use examples; then
		docinto examples
		dodoc examples/*.{c,cpp,py}
	fi
}

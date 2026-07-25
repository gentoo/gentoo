# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Modern solver for linear, quadratic, and mixed-integer programs"
HOMEPAGE="https://highs.dev/
	https://github.com/ERGO-Code/HiGHS"
SRC_URI="https://github.com/ERGO-Code/HiGHS/releases/download/v${PV}/source-archive.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/HiGHS"
LICENSE="MIT"
SLOT="0/1"  # soname major
KEYWORDS="~amd64 ~riscv"

# USE=zlib was removed because the profiles have it on by default and it
# pulls in a bundled copy of the zstr library.
IUSE="examples hipo index64 test +threads"

RESTRICT="!test? ( test )"

# Our unbundled sci-libs/{amd,metis} that are dependencies of HiPO don't
# support 64-bit indexes. HiGHS patches the bundled versions for this.
REQUIRED_USE="?? ( hipo index64 )"

# We use dev-libs/boost to unbundle pdqsort. Catch-2.x is bundled, and
# just switching the include to use catch-3.x doesn't seem to work.
BDEPEND="dev-cpp/cli11
	dev-libs/boost
	test? ( =dev-cpp/catch-2* )"

RDEPEND="
	   hipo? (
			sci-libs/amd
			sci-libs/metis
			virtual/cblas
	   )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/highs-1.14.0-ignore-test-iterations.patch"
	"${FILESDIR}/highs-1.14.0-leave-rpath-alone.patch"
	"${FILESDIR}/highs-1.14.0-vector-oob.patch"
	"${FILESDIR}/highs-1.14.0-unbundle-amd.patch"
	"${FILESDIR}/highs-1.14.0-unbundle-cli11.patch"
	"${FILESDIR}/highs-1.14.0-unbundle-metis.patch"
	"${FILESDIR}/highs-1.14.0-unbundle-pdqsort.patch"
	"${FILESDIR}/highs-1.14.0-unbundle-zstr.patch"
)

pkg_setup() {
	if tc-is-clang; then
		ewarn "WARNING: clang builds have known problems:"
		ewarn
		ewarn "  https://github.com/ERGO-Code/HiGHS/issues/2996"
		ewarn
	fi
}

src_prepare() {
	# Sometimes the .git directory makes it into the release tarballs
	# and cmake will waste time computing the latest commit.
	rm -rf .git || die

	# Unbundle with sed.
	rm extern/catch.hpp || die
	find ./check -type f -name '*.cpp' -execdir \
		 sed -e 's~"catch.hpp"~<catch2/catch.hpp>~' -i {} + || die

	# We unbundle dev-cpp/cli11 (in one place only) with a patch.
	rm extern/CLI11.hpp || die

	# Unbundle header-only library pdqsort, in concert with a patch. The
	# find/sed helps keep the size of the patch down.
	rm -r extern/pdqsort || die
	find ./highs -type f \( -name '*.cc' -o -name '*.cpp' \) -execdir \
		 sed \
			-e 's~"[a-z/\.]*/pdqsort.h"~<boost/sort/pdqsort/pdqsort.hpp>~' \
			-e 's~pdqsort(~boost::sort::pdqsort(~g' \
			-e 's~pdqsort_branchless(~boost::sort::pdqsort_branchless(~g' \
			-i {} + || die

	# Just a precaution, never use the bundled libraries. Zstr is
	# "unbundled" via -DZLIB=OFF. Unfortunately, rcm remains bundled.
	rm -r extern/{amd,metis,zstr} || die

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
		-DPYTHON_BUILD_SETUP=OFF
		-DUSE_DOTNET_STD_21=OFF
		-DZLIB=OFF
	)

	# Append this conditionally; otherwise we get an unused variable
	# warning from the non-HiPO build.
	use hipo && mycmakeargs+=( -DBLA_PKGCONFIG_BLAS=cblas )

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

src_test() {
	if tc-is-clang; then
		ewarn "Clang builds always fail their tests, skipping..."
	else
		cmake_src_test
	fi
}

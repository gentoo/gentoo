# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_PN=OpenEXR

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://openexr.com/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/openexr.git"
	SLOT="0/9999" # based on SONAME
else
	SRC_URI="
		https://github.com/AcademySoftwareFoundation/openexr/releases/download/v${PV}/openexr-${PV}.tar.gz
		test? (
			tools? (
				https://github.com/AcademySoftwareFoundation/openexr-images/archive/refs/tags/v1.0.tar.gz
					-> openexr-images-1.0.tar.gz
			)
		)
	"
	# -ppc -sparc because broken on big endian, bug #818424
	KEYWORDS="~amd64 ~arm ~arm64 ~loong -ppc ~ppc64 ~riscv -sparc ~x86 ~x64-macos"

	SLOT="0/$(ver_cut 1)$(( $(ver_cut 2)-1))" # based on SONAME -> OPENEXR_LIB_SOVERSION
fi

LICENSE="BSD"

IUSE="cpu_flags_x86_avx doc examples large-stack tbb test threads tools"
REQUIRED_USE="doc? ( tools )"
RESTRICT="!test? ( test )"

# we want to rebuild on imath subslot change even if it's using only headers
RDEPEND="
	app-arch/libdeflate[zlib(+)]
	>=dev-libs/imath-3.1.6:=
	media-libs/openjph:=
	tbb? (
		dev-cpp/tbb:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( sys-apps/help2man )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-bintests-iff-utils.patch"
	"${FILESDIR}/${PN}-3.4.4-tbb-link-private.patch"
)

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md )

src_prepare() {
	# TODO turn this into a patch
	# Fix path for testsuite
	sed -e "s:/var/tmp/:${T}:" \
		-i \
			"src/test/${MY_PN}Test/tmpDir.h" \
			"src/test/${MY_PN}CoreTest/main.cpp" \
		|| die "failed to set temp path for tests"

	sed -e "/include.*clang-format.cmake)/s/^/# /g" \
		-i CMakeLists.txt || die

	cmake_src_prepare

	if use test && use tools; then
		mkdir -p "${BUILD_DIR}/src/test" || die
		ln -sr "${WORKDIR}/openexr-images-1.0" "${BUILD_DIR}/src/test/bin" || die
	fi

}

src_configure() {
	if use x86; then
		replace-cpu-flags native i686
	fi

	local mycmakeargs=(
		-DOPENEXR_CXX_STANDARD="17"

		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_WEBSITE="no"

		-DOPENEXR_BUILD_EXAMPLES="$(usex examples)"
		-DOPENEXR_BUILD_LIBS="yes"
		# -DOPENEXR_BUILD_OSS_FUZZ="no"
		-DOPENEXR_BUILD_PYTHON="no"
		-DOPENEXR_BUILD_TOOLS="$(usex tools)"

		-DOPENEXR_ENABLE_LARGE_STACK="$(usex large-stack)"
		-DOPENEXR_ENABLE_THREADING="$(usex threads)"

		-DOPENEXR_FORCE_INTERNAL_DEFLATE="no"
		-DOPENEXR_FORCE_INTERNAL_IMATH="no"
		-DOPENEXR_FORCE_INTERNAL_OPENJPH="no"

		-DOPENEXR_INSTALL="yes"
		-DOPENEXR_INSTALL_DEVELOPER_TOOLS="no" # "$(usex tools)"
		-DOPENEXR_INSTALL_DOCS="$(usex doc)"
		-DOPENEXR_INSTALL_PKG_CONFIG="yes"
		-DOPENEXR_INSTALL_TOOLS="$(usex tools)"

		-DOPENEXR_TEST_LIBRARIES="$(usex test)"
		-DOPENEXR_TEST_PYTHON="no" # "$(usex test "$(usex python)")"
		-DOPENEXR_TEST_TOOLS="$(usex test "$(usex tools)")"

		-DOPENEXR_USE_CLANG_TIDY="no" # don't look for clang-tidy
		-DOPENEXR_USE_DEFAULT_VISIBILITY="no" # don't look for clang-tidy
		-DOPENEXR_USE_TBB="$(usex tbb)"
	)

	if use test; then
		if [[ "${EXPENSIVE_TESTS:-0}" -gt 0 ]]; then
			# OPENEXR_RUN_FUZZ_TESTS depends on BUILD_TESTING, see
			#   - https://bugs.gentoo.org/925128
			#   - https://openexr.com/en/latest/install.html#component-options

			# NOTE: the fuzz tests are very slow
			mycmakeargs+=(
				-DOPENEXR_BUILD_OSS_FUZZ="yes"
				-DOPENEXR_RUN_FUZZ_TESTS="yes"
			)
		else
			mycmakeargs+=(
				-DOPENEXR_BUILD_OSS_FUZZ="no"
			)
		fi
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()

	if use arm64; then
		CMAKE_SKIP_TESTS+=(
			# bug #922247
			'OpenEXRCore.testDWAACompression'
			'OpenEXRCore.testDWABCompression'
		)
	fi

	if use x86; then
		CMAKE_SKIP_TESTS+=(
			'^OpenEXR.testDwaLookups$'
		)
	fi

	cmake_src_test
}

src_install() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	cmake_src_install
}

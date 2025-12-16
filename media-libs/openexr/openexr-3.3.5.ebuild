# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_PN=OpenEXR

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://openexr.com/"
SRC_URI="
	https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		utils? (
			https://github.com/AcademySoftwareFoundation/openexr-images/archive/refs/tags/v1.0.tar.gz
				-> openexr-images-1.0.tar.gz
		)
	)
"

LICENSE="BSD"
SLOT="0/32" # based on SONAME
# -ppc -sparc because broken on big endian, bug #818424
KEYWORDS="~amd64 ~arm ~arm64 ~loong -ppc ~ppc64 ~riscv -sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

IUSE="cpu_flags_x86_avx doc examples large-stack utils test threads"
REQUIRED_USE="doc? ( utils )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/libdeflate:=[zlib(+)]
	>=dev-libs/imath-3.1.6:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( sys-apps/help2man )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-bintests-iff-utils.patch"
)

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md )

src_prepare() {
	# Fix path for testsuite
	sed -e "s:/var/tmp/:${T}:" \
		-i "${S}"/src/test/${MY_PN}Test/tmpDir.h || die "failed to set temp path for tests"

	sed -e "s:if(INSTALL_DOCS):if(OPENEXR_INSTALL_DOCS):" \
		-i docs/CMakeLists.txt || die

	cmake_src_prepare

	if use test && use utils; then
		IMAGES=(
			Beachball/multipart.0001.exr
			Beachball/singlepart.0001.exr
			Chromaticities/Rec709.exr
			Chromaticities/Rec709_YC.exr
			Chromaticities/XYZ.exr
			Chromaticities/XYZ_YC.exr
			LuminanceChroma/Flowers.exr
			LuminanceChroma/Garden.exr
			MultiResolution/ColorCodedLevels.exr
			MultiResolution/WavyLinesCube.exr
			MultiResolution/WavyLinesLatLong.exr
			MultiView/Adjuster.exr
			TestImages/GammaChart.exr
			TestImages/GrayRampsHorizontal.exr
			v2/LeftView/Balls.exr
			v2/Stereo/Trunks.exr
		)

		mkdir -p "${BUILD_DIR}/src/test/bin" || die

		for image in "${IMAGES[@]}"; do
			mkdir -p "${BUILD_DIR}/src/test/bin/$(dirname "${image}")" || die
			cp -a "${WORKDIR}/openexr-images-1.0/${image}" "${BUILD_DIR}/src/test/bin/${image}" || die
		done
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
		-DOPENEXR_BUILD_PYTHON="no"
		-DOPENEXR_BUILD_TOOLS="$(usex utils)"
		-DOPENEXR_ENABLE_LARGE_STACK="$(usex large-stack)"
		-DOPENEXR_ENABLE_THREADING="$(usex threads)"

		-DOPENEXR_INSTALL="yes"
		-DOPENEXR_INSTALL_DOCS="$(usex doc)"
		-DOPENEXR_INSTALL_PKG_CONFIG="yes"
		-DOPENEXR_INSTALL_TOOLS="$(usex utils)"

		-DOPENEXR_USE_CLANG_TIDY="no" # don't look for clang-tidy

		-DOPENEXR_FORCE_INTERNAL_DEFLATE="no"
		-DOPENEXR_FORCE_INTERNAL_IMATH="no"
	)

	if [[ "${EXPENSIVE_TESTS:-0}" -gt 0 ]]; then
		if use test; then
			# OPENEXR_RUN_FUZZ_TESTS depends on BUILD_TESTING, see
			#   - https://bugs.gentoo.org/925128
			#   - https://openexr.com/en/latest/install.html#component-options

			# NOTE: the fuzz tests are very slow
			mycmakeargs+=( -DOPENEXR_RUN_FUZZ_TESTS="ON" )
		fi
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()

	use arm64 && CMAKE_SKIP_TESTS+=(
		# bug #922247
		'OpenEXRCore.testDWAACompression'
		'OpenEXRCore.testDWABCompression'
	)
	use x86 && CMAKE_SKIP_TESTS+=(
		'^OpenEXR.testDwaLookups$'
	)

	cmake_src_test
}

src_install() {
	use examples && docompress -x "/usr/share/doc/${PF}/examples"

	cmake_src_install
}

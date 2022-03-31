# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN=OpenEXR
MY_PV=$(ver_cut 1)
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3/30" # based on SONAME
# -ppc -sparc because broken on big endian, bug #818424
KEYWORDS="amd64 ~arm arm64 ~ia64 -ppc ~ppc64 ~riscv -sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx doc examples large-stack static-libs utils test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/imath-3.1.0:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-python/breathe )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-0001-changes-needed-for-proper-slotting.patch
	"${FILESDIR}"/${PN}-3.1.1-0002-add-version-to-binaries-for-slotting.patch
	"${FILESDIR}"/${PN}-3.1.1-0003-disable-failing-test.patch
)

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md docs/SymbolVisibility.md )

src_prepare() {
	# Fix path for testsuite
	sed -e "s:/var/tmp/:${T}:" \
		-i "${S}"/src/test/${MY_PN}{,Fuzz,Util}Test/tmpDir.h || die "failed to set temp path for tests"

	cmake_src_prepare

	mv "${S}"/cmake/${MY_PN}.pc.in "${S}"/cmake/${MY_P}.pc.in || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
		-DDOCS=$(usex doc)
		-DOPENEXR_BUILD_TOOLS=$(usex utils)
		-DOPENEXR_ENABLE_LARGE_STACK=$(usex large-stack)
		-DOPENEXR_ENABLE_THREADING=$(usex threads)
		-DOPENEXR_INSTALL_EXAMPLES=$(usex examples)
		-DOPENEXR_INSTALL_PKG_CONFIG=ON
		-DOPENEXR_INSTALL_TOOLS=$(usex utils)
		-DOPENEXR_OUTPUT_SUBDIR="${MY_P}"
		-DOPENEXR_USE_CLANG_TIDY=OFF		# don't look for clang-tidy
	)

	use test && mycmakeargs+=( -DOPENEXR_RUN_FUZZ_TESTS=ON )

	cmake_src_configure
}

src_install() {
	use examples && docompress -x /usr/share/doc/${PF}/examples
	cmake_src_install

	newenvd - 99${PN}3 <<-EOF
		LDPATH=/usr/$(get_libdir)/${MY_P}
	EOF
}

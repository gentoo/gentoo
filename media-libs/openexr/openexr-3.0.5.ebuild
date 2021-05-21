# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic toolchain-funcs

MY_PN=OpenEXR
MY_PV=$(ver_cut 1)
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3/29" # based on SONAME
# imath needs keywording: arm{,64}, hppa, ia64, ppc{,64}, sparc, x64-macos, x86-solaris
KEYWORDS="~amd64 ~ia64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx doc examples large-stack static-libs utils test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	~dev-libs/imath-${PV}:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-0001-changes-needed-for-proper-slotting.patch
	"${FILESDIR}"/${P}-0002-add-version-to-binaries-for-slotting.patch
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
		-DOPENEXR_BUILD_UTILS=$(usex utils)
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
	if use doc; then
		DOCS+=( docs/*.pdf )
	fi
	use examples && docompress -x /usr/share/doc/${PF}/examples
	cmake_src_install

	cat > "${T}"/99${PN}3 <<-EOF || die
	LDPATH=/usr/$(get_libdir)/${MY_P}
	EOF
	doenvd "${T}"/99${PN}3
}

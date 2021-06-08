# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic toolchain-funcs

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0/27" # based on SONAME
# imath needs keywording: arm{,64}, hppa, ia64, ppc{,64}, sparc, x64-macos, x86-solaris
KEYWORDS="~amd64 ~ia64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx doc examples large-stack static-libs utils test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	!media-libs/ilmbase
	dev-libs/imath:=
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md docs/SymbolVisibility.md )

#src_prepare() {
	# Fix path for testsuite
#	sed -i -e "s:/var/tmp/:${T}:" "${S}"/IlmImfTest/tmpDir.h || die "failed to set temp path for tests"

#	if use abi_x86_32 && use test; then
#		eapply "${FILESDIR}/${PN}-2.5.2-0001-IlmImfTest-main.cpp-disable-tests.patch"
#	fi

#	multilib_foreach_abi cmake_src_prepare
#}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
		-DOPENEXR_BUILD_UTILS=$(usex utils)
		-DOPENEXR_ENABLE_LARGE_STACK=$(usex large-stack)
		-DOPENEXR_ENABLE_THREADING=$(usex threads)
		-DOPENEXR_INSTALL_EXAMPLES=$(usex examples)
		-DOPENEXR_INSTALL_PKG_CONFIG=ON
		-DOPENEXR_INSTALL_TOOLS=$(usex utils)
		-DOPENEXR_USE_CLANG_TIDY=OFF		# don't look for clang-tidy
	)

	cmake_src_configure
}

multilib_src_install_all() {
	if use doc; then
		DOCS+=( docs/*.pdf )
	fi
	einstalldocs

	use examples && docompress -x /usr/share/doc/${PF}/examples
}

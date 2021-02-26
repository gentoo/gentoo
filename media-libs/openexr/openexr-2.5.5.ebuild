# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic toolchain-funcs

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/25" # based on SONAME
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx doc examples static-libs utils test"
RESTRICT="!test? ( test )"

RDEPEND="
	~media-libs/ilmbase-${PV}:=[static-libs?,${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}/OpenEXR"

DOCS=( PATENTS README.md )

src_prepare() {
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" "${S}"/IlmImfTest/tmpDir.h || die "failed to set temp path for tests"

	if use abi_x86_32 && use test; then
		eapply "${FILESDIR}/${PN}-2.5.2-0001-IlmImfTest-main.cpp-disable-tests.patch"
	fi

	multilib_foreach_abi cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DINSTALL_OPENEXR_DOCS=$(usex doc)
		-DINSTALL_OPENEXR_EXAMPLES=$(usex examples)
		-DOPENEXR_BUILD_BOTH_STATIC_SHARED=$(usex static-libs)
		-DOPENEXR_BUILD_UTILS=$(usex utils)
		-DOPENEXR_INSTALL_PKG_CONFIG=ON
		-DOPENEXR_USE_CLANG_TIDY=OFF		# don't look for clang-tidy
	)

	cmake_src_configure
}

multilib_src_install_all() {
	if use doc; then
		DOCS+=( doc/*.pdf )
	fi
	einstalldocs

	use examples && docompress -x /usr/share/doc/${PF}/examples
}

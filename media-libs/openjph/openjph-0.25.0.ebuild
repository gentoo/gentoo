# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenJPH"

inherit cmake-multilib

DESCRIPTION="Open source implementation of JPH (high-throughput JPEG2000) library"
HOMEPAGE="https://github.com/aous72/OpenJPH"
SRC_URI="https://github.com/aous72/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/aous72/jp2k_test_codestreams/archive/refs/heads/main.tar.gz -> ${P}-test.tar.gz )"
S="${WORKDIR}/${MY_PN}-${PV}/"

LICENSE="BSD-2"
SLOT="0" # based on SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test tiff"
RESTRICT="!test? ( test )"

RDEPEND="
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
	"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-0.25.0-use_prefetched_test_data_and_gtest.patch
)

src_prepare() {
	cmake_src_prepare

	if use test; then
		mv "${WORKDIR}"/jp2k_test_codestreams-main "${S}"/tests ||
			die "Failed to rename test data"
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DOJPH_ENABLE_TIFF_SUPPORT="$(multilib_native_usex tiff ON OFF)"
		-DOJPH_BUILD_TESTS="$(multilib_native_usex test)"
	)

	cmake_src_configure
}

multilib_src_test() {
	ln -svf "${S}"/tests/jp2k_test_codestreams-main ./tests/jp2k_test_codestreams

	cmake_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	if use doc; then
		doxygen "$S/docs" || die
		dodoc -r html
	fi
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="LucenePlusPlus-rel_${PV}"
inherit edo cmake flag-o-matic

DESCRIPTION="C++ port of Lucene library, a high-performance, full-featured text search engine"
HOMEPAGE="https://github.com/luceneplusplus/LucenePlusPlus"
SRC_URI="https://github.com/luceneplusplus/LucenePlusPlus/archive/rel_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( LGPL-3 Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~hppa ~loong ppc ppc64 ~sparc x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/boost:=[zlib]"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.7-boost-1.85.patch"
	"${FILESDIR}/${PN}-3.0.9-boost-1.87.patch"
	"${FILESDIR}/${PN}-3.0.9-pkgconfig.patch"
	"${FILESDIR}/${PN}-3.0.9-tests-gtest-cstdint.patch"
	"${FILESDIR}/${PN}-3.0.9-cmake4.patch"
	"${FILESDIR}/${PN}-3.0.9-system-gtest.patch"
	"${FILESDIR}/${PN}-3.0.9-gcc15.patch"
	"${FILESDIR}/${PN}-3.0.9-boost-1.89.patch"
)

src_configure() {
	# Can't be tested with LTO because of ODR issues in test mocks
	filter-lto

	local mycmakeargs=(
		-DENABLE_DEMO=OFF
		-DENABLE_TEST=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	edo "${BUILD_DIR}"/src/test/lucene++-tester \
		--test_dir="${S}"/src/test/testfiles \
		--gtest_filter="-ParallelMultiSearcherTest*:SortTest.*:"
}

# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PV=${PV//./-}

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
# NOTE: Follow SONAME variable in CMakeLists.txt
SONAME="11"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="icu test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116.2-r3:=
	icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

DOCS=( README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

PATCHES=(
	"${FILESDIR}/re2-2024.07.02_optional-benchmark.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DRE2_BUILD_BENCHMARK=OFF
		-DRE2_BUILD_TESTING=$(usex test)
		-DRE2_USE_ICU=$(usex icu)
	)
	cmake_src_configure
}

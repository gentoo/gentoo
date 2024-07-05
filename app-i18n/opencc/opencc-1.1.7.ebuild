# Copyright 2010-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-any-r1

DESCRIPTION="Library for conversion between Traditional and Simplified Chinese characters"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenCC-ver.${PV}"

LICENSE="Apache-2.0"
SLOT="0/1.1"
KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/marisa"
DEPEND="${RDEPEND}
	dev-cpp/tclap
	dev-libs/darts
	dev-libs/rapidjson
"
BDEPEND="${PYTHON_DEPS}
	doc? ( app-text/doxygen )
	test? (
		dev-cpp/gtest
		!hppa? ( !sparc? ( dev-cpp/benchmark ) )
	)
"

DOCS=( AUTHORS NEWS.md README.md )

src_prepare() {
	rm -r deps || die

	sed -e "s:\${DIR_SHARE_OPENCC}/doc:share/doc/${PF}:" -i doc/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DENABLE_BENCHMARK=$(if use test && has_version -d dev-cpp/benchmark; then echo ON; else echo OFF; fi)
		-DENABLE_GTEST=$(usex test)
		-DUSE_SYSTEM_DARTS=ON
		-DUSE_SYSTEM_GOOGLE_BENCHMARK=ON
		-DUSE_SYSTEM_GTEST=ON
		-DUSE_SYSTEM_MARISA=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_TCLAP=ON
	)

	cmake_src_configure
}

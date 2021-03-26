# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_7,3_8,3_9})

inherit cmake python-any-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/BYVoid/OpenCC"
fi

DESCRIPTION="Library for conversion between Traditional and Simplified Chinese characters"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0/1.1"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"
DEPEND="dev-cpp/tclap
	dev-libs/darts
	dev-libs/marisa:0=
	dev-libs/rapidjson
	test? (
		dev-cpp/gtest
		!hppa? ( !sparc? ( dev-cpp/benchmark ) )
	)"
RDEPEND="dev-libs/marisa:0="

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/OpenCC-ver.${PV}"
fi

DOCS=(AUTHORS NEWS.md README.md)

src_prepare() {
	rm -r deps || die

	cmake_src_prepare

	sed -e "s:\${DIR_SHARE_OPENCC}/doc:share/doc/${PF}:" -i doc/CMakeLists.txt || die

	# https://github.com/BYVoid/OpenCC/issues/550
	# https://github.com/BYVoid/OpenCC/commit/736b93d3d16fdf0548bdaae2922569199615e919
	sed -e "s:#ifdef ENABLE_DARTS:#if 1:" -i src/Common.hpp || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DENABLE_BENCHMARK=$(if use test && has_version -d dev-cpp/benchmark; then echo ON; else echo OFF; fi)
		-DENABLE_GTEST=$(usex test ON OFF)
		-DUSE_SYSTEM_DARTS=ON
		-DUSE_SYSTEM_GOOGLE_BENCHMARK=ON
		-DUSE_SYSTEM_GTEST=ON
		-DUSE_SYSTEM_MARISA=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_TCLAP=ON
	)

	cmake_src_configure
}

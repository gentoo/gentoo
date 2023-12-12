# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake multiprocessing

DESCRIPTION="RIME (Rime Input Method Engine) core library"
HOMEPAGE="https://rime.im/ https://github.com/rime/librime"
SRC_URI="https://github.com/rime/librime/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2 Boost-1.0 MIT"
SLOT="0/1-${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/glog:=
	>=dev-libs/boost-1.74:=
	app-i18n/opencc:0=
	dev-cpp/yaml-cpp:0=
	dev-libs/leveldb:0=
	dev-libs/marisa:0=
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

DOCS=(CHANGELOG.md README.md)

src_configure() {
	local -x CXXFLAGS="${CXXFLAGS}"

	# for glog
	if use debug; then
		CXXFLAGS+=" -DDCHECK_ALWAYS_ON"
		CMAKE_BUILD_TYPE=Debug
	else
		CXXFLAGS+=" -DNDEBUG"
	fi

	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
		-DENABLE_EXTERNAL_PLUGINS=ON
		-DINSTALL_PRIVATE_HEADERS=ON
	)

	cmake_src_configure
}

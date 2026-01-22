# Copyright 2012-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multiprocessing flag-o-matic

DESCRIPTION="RIME (Rime Input Method Engine) core library"
HOMEPAGE="https://rime.im/ https://github.com/rime/librime"
SRC_URI="https://github.com/rime/librime/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2 Boost-1.0 MIT"
SLOT="0/1-${PV}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-i18n/opencc:=
	dev-cpp/glog:=
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-1.74:=
	dev-libs/leveldb:=
	dev-libs/marisa
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

DOCS=( CHANGELOG.md README.md )

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/944741
	# https://github.com/rime/librime/issues/954
	filter-lto

	# for glog
	if use debug; then
		append-cxxflags -DDCHECK_ALWAYS_ON
		local CMAKE_BUILD_TYPE=Debug
	else
		append-cxxflags -DNDEBUG
	fi

	local mycmakeargs=(
		-DBUILD_TEST=$(usex test)
		-DCMAKE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
		-DENABLE_EXTERNAL_PLUGINS=ON
		-DINSTALL_PRIVATE_HEADERS=ON
	)
	cmake_src_configure
}

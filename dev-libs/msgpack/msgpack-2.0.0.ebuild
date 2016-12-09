# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-c/releases/download/cpp-${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Boost-1.0"
SLOT="2"
IUSE="boost +cxx doc examples static-libs test"

DEPEND="
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
	boost? ( dev-libs/boost[static-libs] )
	doc? ( app-doc/doxygen )
"

DOCS=( README.md )

src_configure() {
	# static is always built
	local mycmakeargs=(
		-DMSGPACK_BOOST="$(usex boost)"
		-DMSGPACK_ENABLE_CXX="$(usex cxx)"
		-DMSGPACK_BUILD_EXAMPLES="$(usex examples)"
		-DMSGPACK_ENABLE_SHARED="$(usex static-libs no yes)"
		-DMSGPACK_BUILD_TESTS="$(usex test)"
	)

	cmake-multilib_src_configure
}

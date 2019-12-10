# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-c/releases/download/cpp-${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="https://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+cxx static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-cflags.patch
	"${FILESDIR}"/${PN}-1.0.0-static.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_configure() {
	local mycmakeargs=(
		-DMSGPACK_ENABLE_CXX=$(usex cxx)
		-DMSGPACK_STATIC=$(usex static-libs)
		-DMSGPACK_BUILD_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}

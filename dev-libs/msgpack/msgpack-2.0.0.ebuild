# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-c.git"
else
	SRC_URI="
	https://github.com/${PN}/${PN}-c/releases/download/cpp-${PV}/${P}.tar.gz
	https://dev.gentoo.org/~monsieurp/dist/${P}-patchset.tar.bz2"

	KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+cxx static-libs test"

DEPEND="
	test? (
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
"

DOCS=( README.md )

PATCHES=(
	"${WORKDIR}"/patchset/${PN}-2.0.0-gcc7-implicit-fallthrough.patch
)

src_configure() {
	local mycmakeargs=(
	    -DMSGPACK_ENABLE_CXX=$(usex cxx)
		-DMSGPACK_STATIC=$(usex static-libs)
	)

	cmake-multilib_src_configure
}

# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=5b143513263133af2b95547e97c07cebeb72bf72

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/facebookincubator/gloo/"
SRC_URI="https://github.com/facebookincubator/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libuv mpi redis ssl test"

RDEPEND="
	libuv? ( dev-libs/libuv )
	mpi? ( virtual/mpi )
	redis? (
		dev-db/redis
		dev-libs/hiredis
	)
	ssl? ( dev-libs/openssl:0/1.1 )
"
DEPEND="${RDEPEND}
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="test" # For some test the network is needed

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_LIBUV=$(usex libuv ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_TCP_OPENSSL_LINK=$(usex ssl ON OFF)
	)
	cmake_src_configure
}

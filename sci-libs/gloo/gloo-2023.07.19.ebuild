# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake cuda

CommitId=cf1e1abc95d0b961222ee82b6935f76250fbcf16

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/facebookincubator/gloo/"
SRC_URI="https://github.com/facebookincubator/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda libuv mpi redis ssl test"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	libuv? ( dev-libs/libuv )
	mpi? ( virtual/mpi )
	redis? (
		dev-db/redis
		dev-libs/hiredis
	)
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="test" # For some test the network is needed

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${PN}-2022.05.18-gentoo.patch
	"${FILESDIR}"/${PN}-2023.01.17-cuda.patch
	"${FILESDIR}"/${PN}-2023.01.17-ssl3.patch
)

src_prepare() {
	eapply_user
	cmake_src_prepare
	use cuda && cuda_add_sandbox
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DGLOO_USE_CUDA_TOOLKIT=$(usex cuda ON OFF)
		-DUSE_LIBUV=$(usex libuv ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_TCP_OPENSSL_LINK=$(usex ssl ON OFF)
	)
	if use cuda; then
		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		)
	fi
	cmake_src_configure
}

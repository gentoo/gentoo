# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake cuda

CommitId=10909297fedab0a680799211a299203e53515032

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/facebookincubator/gloo/"
SRC_URI="https://github.com/facebookincubator/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda libuv mpi redis ssl test"

RDEPEND="
	cuda? ( <dev-util/nvidia-cuda-toolkit-12:= )
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

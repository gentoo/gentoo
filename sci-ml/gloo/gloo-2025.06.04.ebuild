# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake cuda

CommitId=c7b7b022c124d9643957d9bd55f57ac59fce8fa2

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/facebookincubator/gloo/"
SRC_URI="https://github.com/facebookincubator/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

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

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-2023.01.17-cuda.patch
	"${FILESDIR}"/${P}-ssl3.patch
	"${FILESDIR}"/${PN}-2023.12.03-gcc15.patch
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
		addpredict "/proc/self/task"

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		)
	fi
	cmake_src_configure
}

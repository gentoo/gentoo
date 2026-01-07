# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ROCM_VERSION=6.3
inherit cmake cuda flag-o-matic rocm

CommitId=3135b0b41b67dde590eef0938a0bf3d6238df5f7

# Need half/bf16 headers from any pytorch
PYTORCH_PV=2.9.0
PYTORCH_P=pytorch-${PYTORCH_PV}

DESCRIPTION="library of floating-point neural network inference operators"
HOMEPAGE="https://github.com/facebookincubator/gloo/"
SRC_URI="
	https://github.com/facebookincubator/${PN}/archive/${CommitId}.tar.gz -> ${P}.tar.gz

	cuda? ( https://github.com/pytorch/pytorch/archive/refs/tags/v${PYTORCH_PV}.tar.gz -> ${PYTORCH_P}.tar.gz )
	rocm? ( https://github.com/pytorch/pytorch/archive/refs/tags/v${PYTORCH_PV}.tar.gz -> ${PYTORCH_P}.tar.gz )
"

S="${WORKDIR}"/${PN}-${CommitId}
PYTORCH_S="${WORKDIR}"/${PYTORCH_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda libuv mpi redis rocm ssl test"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	libuv? ( dev-libs/libuv )
	mpi? ( virtual/mpi )
	redis? (
		dev-db/redis
		dev-libs/hiredis
	)
	rocm? ( dev-util/hip:= )
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}
	cuda? ( sci-ml/caffe2[cuda] )
"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="test" # For some test the network is needed

PATCHES=(
	"${FILESDIR}"/${PN}-2025.06.04-gentoo.patch
	"${FILESDIR}"/${PN}-2025.06.04-ssl3.patch
	"${FILESDIR}"/${PN}-2023.12.03-gcc15.patch
)

src_prepare() {
	if use cuda || use rocm; then
		touch "${PYTORCH_S}"/torch/headeronly/macros/cmake_macros.h || die
	fi
	cmake_src_prepare
	use cuda && cuda_add_sandbox
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
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
			-DGLOO_TORCH_DIR="${PYTORCH_S}"
			-DGLOO_USE_TORCH_DTYPES=ON
			-DUSE_CUDA=ON
		)
	fi
	if use rocm; then
		export ROCM_PATH="${EPREFIX}/usr"
		export GLOO_ROCM_ARCH="$(get_amdgpu_flags)"
		mycmakeargs+=(
			-DCMAKE_HIP_ARCHITECTURES="${GLOO_ROCM_ARCH}"
			-DCMAKE_REQUIRE_FIND_PACKAGE_HIP=$(usex rocm ON OFF)
			-DGLOO_TORCH_DIR="${PYTORCH_S}"
			-DHIP_CXX_FLAGS="$(test-flags-HIPCXX ${CXXFLAGS})"
			-DGLOO_USE_TORCH_DTYPES=ON
			-DUSE_ROCM=ON
		)
	fi
	cmake_src_configure
}

# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-r1 cmake

MYPN=pytorch
MYP=${MYPN}-${PV}

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ffmpeg nnpack +numpy opencl opencv openmp qnnpack xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( opencv )
"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/cpuinfo
	dev-libs/libfmt
	dev-libs/protobuf
	dev-libs/pthreadpool
	dev-libs/sleef
	sci-libs/lapack
	sci-libs/onnx
	sci-libs/foxi
	ffmpeg? ( media-video/ffmpeg:= )
	nnpack? ( sci-libs/NNPACK )
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv:= )
	qnnpack? ( sci-libs/QNNPACK )
	xnnpack? ( sci-libs/XNNPACK )
"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/pocketfft
	dev-libs/flatbuffers
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/${MYP}

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.12.0-install-dirs.patch
)

src_prepare() {
	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd
}

src_configure() {
	python_setup
	local mycmakeargs=(
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON

		-DUSE_CCACHE=OFF
		-DUSE_CUDA=OFF # TODO
		-DUSE_CUDNN=OFF # TODO
		-DUSE_FAST_NVCC=OFF # TODO
		#-DCUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-Auto}"
		-DUSE_DISTRIBUTED=OFF
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=OFF # TODO
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GFLAGS=OFF # TODO
		-DUSE_GLOG=OFF # TODO
		-DUSE_GLOO=OFF
		-DUSE_KINETO=OFF # TODO
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
		-DUSE_MKLDNN=OFF
		-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=OFF # TODO
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_BIND11=ON
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_TENSORPIPE=OFF

		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR=/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR=/usr/$(get_libdir)
	)
	cmake_src_configure
}

python_install() {
	python_domodule python/caffe2
	python_domodule python/torch
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt

	rm -rf python
	mkdir -p python/torch || die
	mv "${D}"/usr/lib/python*/site-packages/caffe2 python/ || die
	cp torch/version.py python/torch/ || die
	python_foreach_impl python_install
}

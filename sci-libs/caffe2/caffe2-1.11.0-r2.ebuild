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
RESTRICT="test"
IUSE="nnpack xnnpack"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/cpuinfo
	dev-libs/libfmt
	dev-libs/protobuf
	dev-libs/sleef
	sci-libs/lapack
	sci-libs/onnx
	sci-libs/foxi
	nnpack? ( sci-libs/NNPACK )
	xnnpack? ( sci-libs/XNNPACK )
"
DEPEND="${RDEPEND}
	dev-libs/FP16
	dev-libs/pocketfft
	dev-libs/flatbuffers
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd
}

src_configure() {
	python_setup
	local mycmakeargs=(
		-DUSE_KINETO=OFF
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_BREAKPAD=OFF
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_TENSORPIPE=OFF
		-DUSE_GLOO=OFF
		-DUSE_SYSTEM_FP16=ON
		-DUSE_FBGEMM=OFF
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_QNNPACK=OFF
		-DUSE_SYSTEM_CPUINFO=ON
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DUSE_MKLDNN=OFF
		-DUSE_NUMPY=OFF
		-DUSE_OPENMP=OFF
		-DUSE_DISTRIBUTED=OFF
		-DUSE_CUDA=OFF
		-DUSE_NCCL=OFF
		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR=/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR=/usr/$(get_libdir)
		-DUSE_CCACHE=OFF
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_XNNPACK=$(usex xnnpack ON OFF)
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack ON OFF)
		-DUSE_NNPACK=$(usex nnpack ON OFF)
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

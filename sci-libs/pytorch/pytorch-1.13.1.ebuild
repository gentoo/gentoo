# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9,10} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
RDEPEND="
	${PYTHON_DEPS}
	~sci-libs/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	eapply \
		"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch \
		"${FILESDIR}"/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch \
		"${FILESDIR}"/${P}-global-dlopen.patch \
		"${FILESDIR}"/pytorch-1.7.1-torch_shm_manager.patch \
		"${FILESDIR}"/${PN}-1.13.0-setup.patch \

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die
	distutils-r1_src_prepare
}

src_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	BUILD_DIR= \
	distutils-r1_src_compile
}

src_install() {
	USE_SYSTEM_LIBS=ON distutils-r1_src_install
}

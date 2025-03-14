# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
inherit distutils-r1 prefix

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
	>=sci-libs/caffe2-2.5.1-r5
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	eapply "${FILESDIR}"/${P}-dontbuildagain.patch

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die
	distutils-r1_src_prepare

	# Get object file from caffe2
	cp /var/lib/caffe2/functorch.so functorch/functorch.so || die

	hprefixify tools/setup_helpers/env.py
}

python_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	distutils-r1_python_compile develop sdist
}

python_install() {
	USE_SYSTEM_LIBS=ON distutils-r1_python_install
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 virtualx pypi

DESCRIPTION="Jupyter kernel for octave"
HOMEPAGE="
	https://github.com/Calysto/octave_kernel/
	https://pypi.org/project/octave-kernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/metakernel-0.24.0[${PYTHON_USEDEP}]
	sci-mathematics/octave"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/jupyter-kernel-test[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	virtx eunittest
}

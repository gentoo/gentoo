# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 virtualx pypi

DESCRIPTION="Jupyter kernel for octave"
HOMEPAGE="
	https://github.com/Calysto/octave_kernel/
	https://pypi.org/project/octave-kernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/ipykernel-6.22.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-8.1.0[${PYTHON_USEDEP}]
	>=dev-python/metakernel-1.0[${PYTHON_USEDEP}]
	sci-mathematics/octave
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/jupyter-kernel-test[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

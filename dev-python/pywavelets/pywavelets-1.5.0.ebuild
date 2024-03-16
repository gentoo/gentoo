# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_PN="PyWavelets"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Discrete Wavelet Transforms in Python"
HOMEPAGE="
	https://pywavelets.readthedocs.io/en/latest/
	https://github.com/PyWavelets/pywt/
	https://pypi.org/project/PyWavelets/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	<dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22.4[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	>=dev-python/cython-0.29.35[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	rm -rf pywt || die
	epytest --pyargs pywt
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		docinto examples
		dodoc -r demo
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

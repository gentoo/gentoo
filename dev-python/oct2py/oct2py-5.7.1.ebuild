# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="
	https://github.com/blink1073/oct2py
	https://blink1073.github.io/oct2py/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=dev-python/numpy-1.12[${PYTHON_USEDEP}]
	>=dev-python/octave-kernel-0.34.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.17[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# No graphics toolkit available: 743589
	"oct2py/ipython/tests/test_octavemagic.py::OctaveMagicTest::test_octave_plot"
)

distutils_enable_sphinx docs/source \
	dev-python/numpydoc \
	dev-python/pydata-sphinx-theme \
	dev-python/myst-parser \
	dev-python/sphinxcontrib-spelling
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

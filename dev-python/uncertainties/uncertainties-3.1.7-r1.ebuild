# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python module for calculations with uncertainties"
HOMEPAGE="
	https://pythonhosted.org/uncertainties/
	https://github.com/lebigot/uncertainties/
	https://pypi.org/project/uncertainties/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc --no-autodoc

src_prepare() {
	# not used in py3, see https://github.com/lebigot/uncertainties/pull/168
	sed -i -e '/future/d' setup.py || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "numpy support" dev-python/numpy
}

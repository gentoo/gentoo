# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Python ensemble sampling toolkit for affine-invariant MCMC"
HOMEPAGE="
	https://emcee.readthedocs.io/en/stable/
	https://github.com/dfm/emcee/
	https://pypi.org/project/emcee/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

DOCS=( AUTHORS.rst README.rst )

src_prepare() {
	# unnecessary dep
	sed -i -e '/wheel/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p xdist -n "$(makeopts_jobs)" --dist=worksteal
}

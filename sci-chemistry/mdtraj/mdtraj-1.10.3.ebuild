# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Read, write and analyze MD trajectories with only a few lines of Python code"
HOMEPAGE="https://mdtraj.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
LICENSE="LGPL-2.1+"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tables[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter-client[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-1.10.3-tests.py" )

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s:re.match('build.*(mdtraj.*)', output_dir).group(1):'.':g" \
		-i basesetup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf mdtraj* || die
	epytest tests
	epytest examples
}

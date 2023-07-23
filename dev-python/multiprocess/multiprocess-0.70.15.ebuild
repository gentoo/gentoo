# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Better multiprocessing and multithreading in Python"
HOMEPAGE="
	https://github.com/uqfoundation/multiprocess/
	https://pypi.org/project/multiprocess/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dill[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" py${EPYTHON#python}/multiprocess/tests/__main__.py -v || die
}

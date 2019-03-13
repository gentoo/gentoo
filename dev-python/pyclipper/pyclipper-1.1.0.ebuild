# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Cython wrapper for the C++ translation of the Angus Johnson's Clipper library"
HOMEPAGE="https://github.com/fonttools/pyclipper"
SRC_URI="https://github.com/fonttools/pyclipper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools-git[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
"
RDEPEND=""

python_test() {
	esetup.py test
}

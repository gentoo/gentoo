# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A goodie-bag of unix shell and environment tools for py.test"
HOMEPAGE="https://github.com/man-group/pytest-plugins https://pypi.org/project/pytest-shutil/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"
# block pytest plugins that will be broken by the upgrade
RDEPEND+="
	!<dev-python/pytest-virtualenv-1.7.0-r1[python_targets_python2_7(-)]
"

BDEPEND="
	${RDEPEND}
	dev-python/setuptools-git[${PYTHON_USEDEP}]
"

distutils_enable_tests --install setup.py

python_prepare_all() {
	# keeps trying to install this in tests
	sed -i 's:path.py::' setup.py || die

	distutils-r1_python_prepare_all
}

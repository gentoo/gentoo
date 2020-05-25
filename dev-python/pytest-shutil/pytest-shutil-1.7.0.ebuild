# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="A goodie-bag of unix shell and environment tools for py.test"
HOMEPAGE="https://github.com/man-group/pytest-plugins https://pypi.org/project/pytest-shutil/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	dev-python/setuptools-git[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# keeps trying to install this in tests
	sed -i 's:path.py::' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# at this point let's not fix python2 stuff
	if ! python_is_python3; then
		ewarn "Tests broken on python2, not runninge tests for ${EPYTHON}"
		return 0
	fi

	distutils_install_for_testing

	esetup.py test || die "Tests failed under ${EPYTHON}"
}

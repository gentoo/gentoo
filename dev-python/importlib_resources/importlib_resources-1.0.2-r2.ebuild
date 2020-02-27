# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a backport of Python 3.7's importlib.resources
PYTHON_COMPAT=( pypy3 python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://importlib-resources.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
	virtual/python-typing[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
distutils_enable_sphinx importlib_resources/docs

# https://gitlab.com/python-devs/importlib_resources/issues/71
PATCHES=( "${FILESDIR}/${P}-skip-wheel.patch" )

python_compile() {
	distutils-r1_python_compile
	if ! python_is_python3; then
		rm "${BUILD_DIR}/lib/importlib_resources/_py3.py" || die
	fi
}

python_install() {
	distutils-r1_python_install --skip-build
}

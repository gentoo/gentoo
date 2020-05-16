# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_P="path.py-${PV}"

DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path.py/ https://github.com/jaraco/path.py"
SRC_URI="mirror://pypi/p/path.py/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' python3_{5,6,7} pypy3)
	dev-python/appdirs[${PYTHON_USEDEP}]
	!<dev-python/pytest-shutil-1.7.0-r1
	!<dev-python/pytest-virtualenv-1.7.0-r1"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/path-py-12.0.2-py38.patch"
)

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i "s:setuptools_scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+)[[:space:]]*::" \
		setup.cfg || die

	# disable flake8 tests
	sed -i -r 's: --flake8:: ; s: --black:: ; s: --cov::' \
		pytest.ini || die

	# fragile test for import time
	sed -i -e 's:test_import_time:_&:' test_path.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=. pytest -v || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_P="path-${PV}"

DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path/ https://github.com/jaraco/path"
SRC_URI="mirror://pypi/p/path/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' python3_{5,6,7} pypy3)
	dev-python/appdirs[${PYTHON_USEDEP}]
	!<dev-python/pytest-shutil-1.7.0-r1
	!<dev-python/pytest-virtualenv-1.7.0-r1"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/path-py-12.0.2-py38.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -e "s/setup_requires = setuptools_scm/version = '${PV}'/" \
		-i setup.cfg || die

	# disable fancy test deps
	sed -e 's: --flake8:: ; s: --black:: ; s: --cov:: ; s: --mypy::' \
		-i pytest.ini || die

	# fragile test for import time
	sed -i -e 's:test_import_time:_&:' test_path.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=. pytest -vv || die
}

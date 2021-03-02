# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

MY_P="path-${PV}"
DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path/ https://github.com/jaraco/path"
SRC_URI="mirror://pypi/p/path/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	!<dev-python/pytest-shutil-1.7.0-r1
	!<dev-python/pytest-virtualenv-1.7.0-r1"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# unreliable, not really meaningful for end users
		test_path.py::TestPerformance
	)

	PYTHONPATH=. pytest -vv ${deselect[@]/#/--deselect } || die
}

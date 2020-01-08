# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

MY_P="path.py-${PV}"

DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="https://pypi.org/project/path.py/ https://github.com/jaraco/path.py"
SRC_URI="mirror://pypi/p/path.py/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed '/setuptools_scm/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Various helpers to pass trusted data to untrusted environments and back"
HOMEPAGE="https://pythonhosted.org/itsdangerous/ https://pypi.org/project/itsdangerous/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# Required for running tests.py
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	if python_is_python3; then
		2to3 -f unicode -nw --no-diffs tests.py
	fi
	"${PYTHON}" tests.py || die "Tests failed under ${EPYTHON}"
}

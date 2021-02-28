# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="Pagination support for flask"
HOMEPAGE="https://flask-paginate.readthedocs.io"
SRC_URI="https://github.com/lixxu/flask-paginate/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	pytest -vv tests/tests.py || die "tests failed with ${EPYTHON}"
}

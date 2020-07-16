# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Easily capture stdout/stderr of the current process and subprocesses"
HOMEPAGE="https://capturer.readthedocs.io/en/latest/
	https://pypi.org/project/capturer/
	https://github.com/xolox/python-capturer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/humanfriendly[${PYTHON_USEDEP}]"

DEPEND="test? ( dev-python/coverage[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	pytest -vv ${PN}/tests.py || die "Tests fail with ${EPYTHON}"
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Human friendly output for text interfaces using Python"
HOMEPAGE="https://pypi.org/project/humanfriendly/
	https://github.com/xolox/python-humanfriendly/
	https://humanfriendly.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		dev-python/coloredlogs[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	pytest -vv ${PN}/tests.py || die "Tests fail with ${EPYTHON}"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="https://github.com/samuelcolvin/pydantic"
# No tests on PyPI: https://github.com/samuelcolvin/pydantic/pull/1976
SRC_URI="https://github.com/samuelcolvin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-email-validator[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# seriously?
	sed -i -e '/CFLAGS/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	# TODO
	epytest --deselect tests/test_hypothesis_plugin.py
}

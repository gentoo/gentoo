# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# At the moment, PyPy3 doesn't have a dataclasses module
# It can probably be added when PyPy3.7 is stable
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="https://github.com/samuelcolvin/pydantic"
# No tests on PyPI: https://github.com/samuelcolvin/pydantic/pull/1976
SRC_URI="https://github.com/samuelcolvin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://github.com/samuelcolvin/pydantic/pull/1977
	"${FILESDIR}/${P}-fix-tests.patch"
	# https://github.com/samuelcolvin/pydantic/pull/1844
	"${FILESDIR}/${P}-py39.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# So we don't need pytest-timeout
	sed -i '/^timeout = /d' setup.cfg || die
	distutils-r1_python_prepare_all
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Run-time type checker for Python"
HOMEPAGE="https://github.com/agronholm/typeguard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# typeguard has to be installed before it can be tested.
# https://github.com/agronholm/typeguard/issues/176#issuecomment-780398970
BDEPEND="
	test? (
		=dev-python/typeguard-${PV}[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x MYPYPATH=${PYTHONPATH}
	epytest
}

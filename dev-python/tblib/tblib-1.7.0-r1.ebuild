# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Traceback fiddling library for Python"
HOMEPAGE="
	https://github.com/ionelmc/python-tblib/
	https://pypi.org/project/tblib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

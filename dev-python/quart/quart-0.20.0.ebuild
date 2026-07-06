# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="A Python ASGI web microframework with the same API as Flask"
HOMEPAGE="
	https://github.com/pallets/quart/
	https://pypi.org/project/Quart/
"
# no tests in sdist as of 0.20.0
SRC_URI="
	https://github.com/pallets/quart/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.6[${PYTHON_USEDEP}]
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/flask-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/hypercorn-0.11.2[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/python-dotenv[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# https://github.com/pallets/quart/issues/465
		'tests/test_blueprints.py::test_cli_blueprints[cli_group2-args2]'
	)

	epytest -o addopts=
}

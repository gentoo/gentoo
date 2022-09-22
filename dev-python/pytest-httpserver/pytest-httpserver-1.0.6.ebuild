# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="HTTP server for pytest to test HTTP clients"
HOMEPAGE="
	https://github.com/csernazs/pytest-httpserver/
	https://pypi.org/project/pytest-httpserver/
"
SRC_URI="
	https://github.com/csernazs/pytest-httpserver/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# tests from building release artifacts
		tests/test_release.py
	)

	epytest -p no:localserver
}

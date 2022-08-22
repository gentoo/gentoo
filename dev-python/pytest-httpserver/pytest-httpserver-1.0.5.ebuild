# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="HTTP server for pytest to test HTTP clients"
HOMEPAGE="https://github.com/csernazs/pytest-httpserver"
SRC_URI="
	https://github.com/csernazs/pytest-httpserver/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/werkzeug[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/^include = \[/,/\]/d' pyproject.toml || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest -p no:localserver
}

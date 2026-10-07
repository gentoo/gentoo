# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="BDD library for the pytest runner"
HOMEPAGE="https://pytest-bdd.readthedocs.io/"
SRC_URI="
	https://github.com/pytest-dev/pytest-bdd/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/gherkin-official-33[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/parse-type[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( ${PN} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

DOCS=( AUTHORS.rst CHANGES.rst README.rst )

python_test() {
	local -x COLUMNS=80
	epytest
}

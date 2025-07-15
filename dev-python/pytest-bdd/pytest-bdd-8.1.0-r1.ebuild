# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="BDD library for the pytest runner"
HOMEPAGE="https://pytest-bdd.readthedocs.io/"
SRC_URI="
	https://github.com/pytest-dev/pytest-bdd/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

RDEPEND="
	dev-python/gherkin-official[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/parse-type[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( ${PN} )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

DOCS=( AUTHORS.rst CHANGES.rst README.rst )

PATCHES=(
	"${FILESDIR}"/${P}-gherkin-bounds.patch
)

src_test() {
	local -x COLUMNS=80

	local EPYTEST_DESELECT=(
		# https://github.com/pytest-dev/pytest-bdd/issues/779
		tests/parser/test_errors.py::test_step_outside_scenario_or_background_error
	)

	distutils-r1_src_test
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="BDD library for the pytest runner"
HOMEPAGE="https://pypi.org/project/pytest-bdd/"
SRC_URI="https://github.com/pytest-dev/pytest-bdd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/glob2[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/parse_type[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]"
BDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest

DOCS=( AUTHORS.rst CHANGES.rst README.rst )

EPYTEST_DESELECT=(
	# result varies depending on current output terminal width
	tests/feature/test_gherkin_terminal_reporter.py::test_verbose_mode_should_preserve_displaying_regular_tests_as_usual
)

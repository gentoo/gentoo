# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
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
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/parse_type[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

DOCS=( AUTHORS.rst CHANGES.rst README.rst )

src_test() {
	# terminal_reporter test needs exact wrapping
	local -x COLUMNS=80

	# hooks output parsing may be affected by other pytest-*, e.g. tornasync
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_bdd.plugin

	distutils-r1_src_test
}

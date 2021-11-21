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
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/glob2[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/parse[${PYTHON_USEDEP}]
	dev-python/parse_type[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]"
BDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest

DOCS=( AUTHORS.rst CHANGES.rst README.rst )

src_test() {
	# terminal_reporter test needs exact wrapping
	local -x COLUMNS=80

	# hooks output parsing may be affected by other pytest-*, e.g. tornasync
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_bdd.plugin

	distutils-r1_src_test
}

# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="pytest plugin: fixtures and code to help with running shell commands on tests"
HOMEPAGE="
	https://pypi.org/project/pytest-shell-utilities/
	https://github.com/saltstack/pytest-shell-utilities
"
SRC_URI="https://github.com/saltstack/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
	sed -e "/setuptools_scm/ d" -i setup.cfg || die
	sed -e "s/tool.setuptools_scm/tool.disabled/" -i pyproject.toml || die

	printf '__version__ = "${PV}"\n' > src/pytestshellutils/version.py || die

	distutils-r1_python_prepare_all
}

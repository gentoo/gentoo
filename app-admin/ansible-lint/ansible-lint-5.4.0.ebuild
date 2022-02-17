# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible-community/ansible-lint"
# PyPI tarballs do not contain all the data files needed by the tests
SRC_URI="https://github.com/ansible-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=app-admin/ansible-2.10[${PYTHON_USEDEP}]
	>=app-admin/ansible-base-2.11.4[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.6[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/rich-9.5.1[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-7.0[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.25.0[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.1.0[${PYTHON_USEDEP}]
	)"

# Skip problematic tests:
#  - test_call_from_outside_venv doesn't play nicely with the sandbox
#  - test_eco tests require Internet access
#  - as of 5.4.0, test_cli_auto_detect fails even when run manually with tox
EPYTEST_DESELECT=(
	test/TestUtils.py::test_cli_auto_detect
	test/test_eco
	test/test_main.py::test_call_from_outside_venv
)

distutils_enable_tests pytest

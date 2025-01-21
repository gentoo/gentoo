# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

# Upstream has stated explicitly that all tests require Internet access
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=app-admin/ansible-core-2.18.1[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-24.10.0[${PYTHON_USEDEP}]
	>=dev-python/black-24.8.0[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.14.0[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.17.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.10.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.18.6[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-8.5.2[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.35.1[${PYTHON_USEDEP}]
	dev-vcs/git"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/jmespath[${PYTHON_USEDEP}]
		dev-python/license-expression[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.6[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-24.7.0-warnings.patch
)

# test_call_from_outside_venv doesn't play nicely with the sandbox
# irrespective of whether Internet access is allowed or not
EPYTEST_DESELECT=(
	test/test_main.py::test_call_from_outside_venv
)

distutils_enable_tests pytest

# Test suite fails to start without this
python_test() {
	epytest test
}

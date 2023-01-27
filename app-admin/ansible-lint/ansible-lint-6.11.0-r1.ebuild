# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Upstream has stated explicitly that all tests require Internet access
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=app-admin/ansible-core-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-2.2.7[${PYTHON_USEDEP}]
	>=dev-python/black-22.8.0[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.17.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/rich-12.0.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.17.21[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-8.3.2[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.26.3[${PYTHON_USEDEP}]
	dev-vcs/git"
BDEPEND="
	>=dev-python/setuptools_scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
	)"

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

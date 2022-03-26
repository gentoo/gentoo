# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Contains functions that facilitate working with various versions of Ansible"
HOMEPAGE="https://pypi.org/project/ansible-compat/ https://github.com/ansible/ansible-compat/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-admin/ansible-base-2.9.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/subprocess-tee-0.3.5[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-6.3.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-markdown[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-plus[${PYTHON_USEDEP}]
	)
"

# All these tests attempt to connect to galaxy.ansible.com
EPYTEST_DESELECT=(
	test/test_runtime.py::test_install_collection
	test/test_runtime.py::test_install_collection_dest
	test/test_runtime.py::test_prepare_environment_with_collections
	test/test_runtime.py::test_prerun_reqs_v1
	test/test_runtime.py::test_prerun_reqs_v2
	test/test_runtime.py::test_require_collection_no_cache_dir
	test/test_runtime.py::test_require_collection_wrong_version
	test/test_runtime.py::test_require_collection
	test/test_runtime.py::test_upgrade_collection
	test/test_runtime_example.py::test_runtime
)

distutils_enable_sphinx docs \
	dev-python/ansible-pygments \
	dev-python/myst_parser \
	dev-python/sphinx_ansible_theme

distutils_enable_tests pytest

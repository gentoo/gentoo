# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYPI_VERIFY_REPO=https://github.com/ansible/ansible-compat
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Contains functions that facilitate working with various versions of Ansible"
HOMEPAGE="
	https://pypi.org/project/ansible-compat/
	https://github.com/ansible/ansible-compat/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

RDEPEND="
	>=app-admin/ansible-core-2.18.6[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.23.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-25.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/subprocess-tee-0.4.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-{mock,plus} )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# remove stupid upstream version block
	sed -i -e 's:2.20.0dev0:0:' src/ansible_compat/prerun.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# All these tests attempt to connect to galaxy.ansible.com
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
		'test/test_runtime.py::test_load_plugins[modules]'
		# pip, failing due to internets
		test/test_runtime_scan_path.py::test_scan_sys_path
		test/test_runtime_scan_path.py::test_ro_venv
		# internets?
		test/test_runtime.py::test_runtime_has_playbook
		# TODO
		test/test_prerun.py::test_get_cache_dir_relative
	)

	epytest -o addopts=
}

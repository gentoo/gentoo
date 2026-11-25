# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="molecule"
PYPI_VERIFY_REPO=https://github.com/ansible/molecule

inherit distutils-r1 optfeature pypi

DESCRIPTION="A toolkit designed to aid in the development and testing of Ansible roles"
HOMEPAGE="
	https://pypi.org/project/molecule/
	https://github.com/ansible/molecule/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="selinux"

RDEPEND="
	>=app-admin/ansible-core-2.18.1[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-25.5.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	<dev-python/click-9[${PYTHON_USEDEP}]
	>=dev-python/click-help-colors-0.9[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.7[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.9.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/pluggy-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-8.2.5[${PYTHON_USEDEP}]
	selinux? ( sys-libs/libselinux[python,${PYTHON_USEDEP}] )
"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		>=app-admin/ansible-lint-26.3.0[${PYTHON_USEDEP}]
		>=app-misc/check-jsonschema-0.28.4-r1[${PYTHON_USEDEP}]
		>=dev-python/ansi2html-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/filelock-3.9.0[${PYTHON_USEDEP}]
		<dev-python/pexpect-5[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.1.0[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-pyproject-verbosity_assertions.patch
	"${FILESDIR}"/${PN}-fix-test-env.patch
)

# deselecting tests which
# - use network
# - have path conflicts (see python_test() ) or
# - require additional modules (ansible-navigator, podman)
EPYTEST_DESELECT=(
	"tests/integration/test_command.py::test_command_dependency"
	"tests/integration/test_command.py::test_sample_collection"
	"tests/integration/test_command.py::test_with_and_without_gitignore"
	"tests/integration/test_command.py::test_podman"
	"tests/integration/test_command.py::test_native_inventory"
	"tests/integration/test_command.py::test_with_backend_as_ansible_navigator"
	"tests/unit/command/test_base.py::test_execute_cmdline_scenarios"
	"tests/unit/command/test_base.py::test_get_configs"
	"tests/unit/model/v2/test_schema.py::test_molecule_schema"
	"tests/unit/provisioner/test_ansible.py::test_playbooks_converge_property"
	"tests/unit/provisioner/test_ansible.py::test_absolute_path_for"
	"tests/unit/provisioner/test_ansible_playbook.py::test_bake_with_ansible_navigator"
	"tests/unit/provisioner/test_ansible_playbooks.py::test_converge_property"
	"tests/unit/provisioner/test_ansible_playbooks.py::test_get_playbook"
	"tests/unit/provisioner/test_ansible_playbooks.py::test_get_ansible_playbook_with_driver_key_when_playbook_key_missing"
	"tests/unit/verifier/test_testinfra.py::test_testinfra_executes_catches_and_exits_return_code"
)

distutils_enable_tests pytest

python_test() {
	export HOME="${T}"
	export ANSIBLE_REMOTE_TEMP="${T}/.ansible/tmp"

	epytest -p no:warnings
}

pkg_postinst() {
	optfeature_header "Some optional packages commonly used in Molecule scenarios:"
	optfeature "checking playbooks for practices and behaviour that can be improved" app-admin/ansible-lint
}

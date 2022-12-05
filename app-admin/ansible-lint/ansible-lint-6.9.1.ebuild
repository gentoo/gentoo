# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
SRC_URI="https://github.com/ansible/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=app-admin/ansible-core-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-2.2.5[${PYTHON_USEDEP}]
	>=dev-python/black-22.8.0[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.17.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/rich-12.0.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.17.21[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-8.3.2[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.26.3[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/setuptools_scm-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-6.8.6_test-module-check.patch
)

# Skip problematic tests:
#  - test_rules_id_format has been giving an internal error since 6.5.4 or so (TODO: follow this up with upstream)
#  - test_call_from_outside_venv doesn't play nicely with the sandbox
#  - all the others require Internet access, mostly in order to access Ansible Galaxy
EPYTEST_DESELECT=(
	test/test_ansiblesyntax.py::test_null_tasks
	test/test_cli_role_paths.py::test_run_playbook_github
	test/test_eco.py
	test/test_examples.py::test_custom_kinds
	test/test_examples.py::test_example
	test/test_import_playbook.py::test_task_hook_import_playbook
	test/test_list_rules.py::test_list_rules_includes_opt_in_rules
	test/test_list_rules.py::test_list_rules_with_format_option
	test/test_list_rules.py::test_list_tags_includes_opt_in_rules
	test/test_main.py::test_call_from_outside_venv
	test/test_prerun.py::test_install_collection
	test/test_prerun.py::test_prerun_reqs_v1
	test/test_prerun.py::test_prerun_reqs_v2
	test/test_prerun.py::test_require_collection_wrong_version
	test/test_profiles.py::test_profile_listing
	test/test_rules_collection.py::test_rich_rule_listing
	test/test_rules_collection.py::test_rules_id_format
	test/test_skip_inside_yaml.py::test_role_meta
	test/test_utils.py::test_cli_auto_detect
	test/test_utils.py::test_template_lookup
	test/test_verbosity.py::test_default_verbosity
)

distutils_enable_tests pytest

# Test suite fails to start without this. Bug in the eclass, maybe?
python_test() {
	epytest test
}

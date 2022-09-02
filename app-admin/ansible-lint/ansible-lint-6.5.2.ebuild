# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
# PyPI tarballs do not contain all the data files needed by the tests
SRC_URI="https://github.com/ansible/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=app-admin/ansible-core-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-2.2.0[${PYTHON_USEDEP}]
	dev-python/black[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.6[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.9.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/rich-9.5.1[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-7.0[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.25.0[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/setuptools_scm-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-6.5.2_test-module-check.patch
)

# Skip problematic tests:
#  - test_call_from_outside_venv doesn't play nicely with the sandbox
#  - all the others require Internet access, mostly in order to access Ansible Galaxy
EPYTEST_DESELECT=(
	test/test_cli_role_paths.py::test_run_playbook_github
	test/test_eco.py
	test/test_examples.py::test_custom_kinds
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
	test/test_skip_inside_yaml.py::test_role_meta
	test/test_utils.py::test_cli_auto_detect
	test/test_utils.py::test_template_lookup
	test/test_verbosity.py::test_default_verbosity
)

distutils_enable_tests pytest

python_test() {
	# Since 6.2.1, without this the test suite still gets confused by the presence of ansible-lint modules
	# in both ${ED} and ${S}.
	cd "${S}" || die

	epytest test
}

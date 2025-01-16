# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="Python command line interface to gitlab API"
HOMEPAGE="https://github.com/python-gitlab/python-gitlab/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-gitlab/python-gitlab"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

BDEPEND="test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		>=dev-python/pytest-console-scripts-1.3.1[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.2[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		)"

RDEPEND=">=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.10.1[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		tests/functional/*
	)
	local EPYTEST_DESELECT=(
		tests/unit/objects/test_packages.py::test_delete_project_package_file_from_package_file_object
		tests/unit/objects/test_badges.py::test_delete_project_badge
		tests/unit/objects/test_badges.py::test_delete_group_badge
		tests/unit/objects/test_group_access_tokens.py::test_revoke_group_access_token
		tests/unit/objects/test_groups.py::test_delete_group_push_rule
		tests/unit/objects/test_groups.py::test_delete_saml_group_link
		tests/unit/objects/test_job_artifacts.py::test_project_artifacts_delete
		tests/unit/objects/test_members.py::test_delete_group_billable_member
		tests/unit/objects/test_packages.py::test_delete_project_package
		tests/unit/objects/test_packages.py::test_delete_project_package_file_from_package_object
		tests/unit/objects/test_packages.py::test_delete_project_package_file_from_package_file_object
		tests/unit/objects/test_personal_access_tokens.py::test_revoke_personal_access_token
		tests/unit/objects/test_personal_access_tokens.py::test_revoke_personal_access_token_by_id
		tests/unit/objects/test_project_access_tokens.py::test_revoke_project_access_token
		tests/unit/objects/test_project_merge_request_approvals.py::test_delete_merge_request_approval_rule
		tests/unit/objects/test_projects.py::test_delete_shared_project_link
		tests/unit/objects/test_projects.py::test_delete_forked_from_relationship
		tests/unit/objects/test_projects.py::test_delete_project_push_rule
		tests/unit/objects/test_registry_repositories.py::test_delete_project_registry_repository
		tests/unit/objects/test_releases.py::test_delete_release_link
		tests/unit/objects/test_secure_files.py::test_remove_secure_file
		tests/unit/objects/test_todos.py::test_todo_mark_all_as_done
		tests/unit/objects/test_topics.py::test_delete_topic
		tests/unit/objects/test_users.py::test_delete_user_identity
		tests/unit/objects/test_variables.py::test_delete_instance_variable
		tests/unit/objects/test_variables.py::test_delete_project_variable
		tests/unit/objects/test_variables.py::test_delete_group_variable
	)
	epytest
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r *.rst docs
}

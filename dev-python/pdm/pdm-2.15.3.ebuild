# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python package and dependency manager supporting the latest PEP standards"
HOMEPAGE="
	https://pdm-project.org/
	https://github.com/pdm-project/pdm/
	https://pypi.org/project/pdm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/blinker[${PYTHON_USEDEP}]
	>=dev-python/dep-logic-0.2.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/truststore[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/hishel[${PYTHON_USEDEP}]
	dev-python/pbs-installer[${PYTHON_USEDEP}]
	dev-python/pyproject-hooks[${PYTHON_USEDEP}]
	>=dev-python/unearth-0.15.0[${PYTHON_USEDEP}]
	<dev-python/findpython-1[${PYTHON_USEDEP}]
	>=dev-python/findpython-0.6.0[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/shellingham[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	>=dev-python/resolvelib-1.0.1[${PYTHON_USEDEP}]
	dev-python/installer[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		'tests/cli/test_build.py::test_build_with_no_isolation[False]'
		tests/test_project.py::test_access_index_with_auth
		"tests/test_project.py::test_find_interpreters_with_PDM_IGNORE_ACTIVE_VENV[True]"
		tests/cli/test_others.py::test_build_distributions
		'tests/models/test_candidates.py::test_expand_project_root_in_url[demo @ file:///${PROJECT_ROOT}/tests/fixtures/artifacts/demo-0.0.1.tar.gz]'
		'tests/models/test_candidates.py::test_expand_project_root_in_url[-e file:///${PROJECT_ROOT}/tests/fixtures/projects/demo-#-with-hash#egg=demo]'
		tests/models/test_candidates.py::test_find_candidates_from_find_links
		tests/cli/test_build.py::test_build_single_module
		tests/cli/test_build.py::test_build_single_module_with_readme
		tests/cli/test_build.py::test_build_package
		tests/cli/test_build.py::test_build_src_package
		tests/cli/test_build.py::test_build_package_include
		tests/cli/test_build.py::test_build_src_package_by_include
		tests/cli/test_build.py::test_build_with_config_settings
		tests/cli/test_build.py::test_cli_build_with_config_settings
		tests/cli/test_build.py::test_build_ignoring_pip_environment
		tests/cli/test_others.py::test_show_self_package
		tests/cli/test_publish.py::test_publish_and_build_in_one_run
		"tests/cli/test_hooks.py::test_hooks[build]"
		"tests/cli/test_hooks.py::test_hooks[publish]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[build-pre_build]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[build-post_build]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[publish-pre_publish]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[publish-pre_build]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[publish-post_build]"
		"tests/cli/test_hooks.py::test_skip_option_from_signal[publish-post_publish]"
		"tests/cli/test_hooks.py::test_skip_all_option_from_signal[:all-build]"
		"tests/cli/test_hooks.py::test_skip_all_option_from_signal[:all-publish]"
		"tests/cli/test_hooks.py::test_skip_all_option_from_signal[:pre,:post-build]"
		"tests/cli/test_hooks.py::test_skip_all_option_from_signal[:pre,:post-publish]"
		"tests/cli/test_hooks.py::test_skip_pre_post_option_from_signal[pre-build]"
		"tests/cli/test_hooks.py::test_skip_pre_post_option_from_signal[pre-publish]"
		"tests/cli/test_hooks.py::test_skip_pre_post_option_from_signal[post-build]"
		"tests/cli/test_hooks.py::test_skip_pre_post_option_from_signal[post-publish]"
		"tests/cli/test_venv.py::test_conda_backend_create[True]"
		"tests/cli/test_venv.py::test_conda_backend_create[False]"
		tests/cli/test_lock.py::test_lock_all_with_excluded_groups
		# hangs on interactive keyring prompts
		tests/cli/test_config.py::test_repository_overwrite_default
		tests/cli/test_config.py::test_hide_password_in_output_repository
		tests/cli/test_config.py::test_hide_password_in_output_pypi
		# junk output, sigh
		tests/cli/test_others.py::test_info_command_json
		# why does it try to use python 2.7?!
		tests/cli/test_run.py::test_import_another_sitecustomize
		# fails in tinderbox (bug #928964)
		tests/test_project.py::test_project_packages_path
	)
	[[ ${EPYTHON} != python3.10 ]] && EPYTEST_DESELECT+=(
		# test seems hardcoded to 3.10
		tests/test_project.py::test_project_packages_path
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest  -m "not network and not integration and not path" \
		-p pytest_mock
}

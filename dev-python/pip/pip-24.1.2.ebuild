# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# please bump dev-python/ensurepip-pip along with this package!

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..13} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="The PyPA recommended tool for installing Python packages"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/
"
SRC_URI="
	https://github.com/pypa/pip/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="MIT"
# bundled deps
LICENSE+=" Apache-2.0 BSD BSD-2 ISC LGPL-2.1+ MPL-2.0 PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc64 ~riscv ~sparc ~x86"
IUSE="test-rust"

# see src/pip/_vendor/vendor.txt
RDEPEND="
	>=dev-python/cachecontrol-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/distlib-0.3.8[${PYTHON_USEDEP}]
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.8[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyproject-hooks-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.0[${PYTHON_USEDEP}]
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
	>=dev-python/resolvelib-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools-69.5.1[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.9.1[${PYTHON_USEDEP}]

	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/ensurepip-setuptools
			dev-python/ensurepip-wheel
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/pretend[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/scripttest[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			dev-python/virtualenv[${PYTHON_USEDEP}]
			dev-python/werkzeug[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			test-rust? (
				dev-python/cryptography[${PYTHON_USEDEP}]
			)
			dev-vcs/git
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/pip-23.1-no-coverage.patch"
		# prepare to unbundle dependencies
		"${FILESDIR}/pip-24.1-unbundle.patch"
	)

	distutils-r1_python_prepare_all

	# unbundle dependencies
	rm -r src/pip/_vendor || die
	find -name '*.py' -exec sed -i \
		-e 's:from pip\._vendor import:import:g' \
		-e 's:from pip\._vendor\.:from :g' \
		{} + || die

	if use test; then
		local wheels=(
			"${BROOT}"/usr/lib/python/ensurepip/{setuptools,wheel}-*.whl
		)
		mkdir tests/data/common_wheels/ || die
		cp "${wheels[@]}" tests/data/common_wheels/ || die
	fi
}

python_compile_all() {
	# 'pip completion' command embeds full $0 into completion script, which confuses
	# 'complete' and causes QA warning when running as "${PYTHON} -m pip".
	# This trick sets correct $0 while still calling just installed pip.
	local pipcmd='import sys; sys.argv[0] = "pip"; __file__ = ""; from pip._internal.cli.main import main; sys.exit(main())'
	"${EPYTHON}" -c "${pipcmd}" completion --bash > completion.bash || die
	"${EPYTHON}" -c "${pipcmd}" completion --zsh > completion.zsh || die
}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return 0
	fi

	local EPYTEST_DESELECT=(
		tests/functional/test_inspect.py::test_inspect_basic
		# Internet
		tests/functional/test_config_settings.py::test_backend_sees_config_via_sdist
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_install.py::test_install_sdist_links
		tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		# broken by system site-packages use
		tests/functional/test_check.py::test_basic_check_clean
		tests/functional/test_check.py::test_check_skip_work_dir_pkg
		tests/functional/test_check.py::test_check_complicated_name_clean
		tests/functional/test_check.py::test_check_development_versions_are_also_considered
		tests/functional/test_freeze.py::test_freeze_with_setuptools
		tests/functional/test_pip_runner_script.py::test_runner_work_in_environments_with_no_pip
		tests/functional/test_uninstall.py::test_basic_uninstall_distutils
		tests/unit/test_base_command.py::test_base_command_global_tempdir_cleanup
		tests/unit/test_base_command.py::test_base_command_local_tempdir_cleanup
		tests/unit/test_base_command.py::test_base_command_provides_tempdir_helpers
		# broken by unbundling
		"tests/functional/test_debug.py::test_debug[vendored library versions:]"
		tests/functional/test_debug.py::test_debug__library_versions
		tests/functional/test_python_option.py::test_python_interpreter
		tests/functional/test_uninstall.py::test_uninstall_non_local_distutils
	)
	local EPYTEST_IGNORE=(
		# requires proxy.py
		tests/functional/test_proxy.py
	)

	if ! has_version "dev-python/cryptography[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/functional/test_install.py::test_install_sends_client_cert
			tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		)
	fi

	local -x PIP_DISABLE_PIP_VERSION_CHECK=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_XDIST=1
	# rerunfailures because test suite breaks if packages are installed
	# in parallel
	epytest -m "not network" -o tmp_path_retention_policy=all \
		-p rerunfailures --reruns=5
}

python_install_all() {
	local DOCS=( AUTHORS.txt docs/html/**/*.rst )
	distutils-r1_python_install_all

	newbashcomp completion.bash pip

	insinto /usr/share/zsh/site-functions
	newins completion.zsh _pip
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1

# setuptools & wheel .whl files are required for testing,
# the exact version is not very important.
SETUPTOOLS_WHL="setuptools-57.4.0-py3-none-any.whl"
WHEEL_WHL="wheel-0.36.2-py2.py3-none-any.whl"
# upstream still requires virtualenv-16 for testing, we are now fetching
# it directly to avoid blockers with virtualenv-20
VENV_PV=16.7.11

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/"
SRC_URI="
	https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://files.pythonhosted.org/packages/py3/s/setuptools/${SETUPTOOLS_WHL}
		https://files.pythonhosted.org/packages/py2.py3/w/wheel/${WHEEL_WHL}
		https://github.com/pypa/virtualenv/archive/${VENV_PV}.tar.gz
			-> virtualenv-${VENV_PV}.tar.gz
	)
"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
SLOT="0"
IUSE="test vanilla"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		!alpha? ( !hppa? ( !ia64? (
			dev-python/cryptography[${PYTHON_USEDEP}]
		) ) )
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-21.3-no-coverage.patch"
		"${FILESDIR}/${P}-cryptography-tests.patch"
	)
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/pip-20.0.2-disable-system-install.patch" )
	fi

	distutils-r1_python_prepare_all

	if use test; then
		mkdir tests/data/common_wheels/ || die
		cp "${DISTDIR}"/{${SETUPTOOLS_WHL},${WHEEL_WHL}} \
			tests/data/common_wheels/ || die
	fi
}

python_test() {
	if [[ ${EPYTHON} == pypy* ]]; then
		ewarn "Skipping tests on ${EPYTHON} since they are very broken"
		return 0
	fi

	local EPYTEST_DESELECT=(
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_list.py::test_multiple_exclude_and_normalization
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-download]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-install]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-list]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-wheel]'
		tests/functional/test_install.py::test_install_pip_does_not_modify_pip_when_satisfied
		# Internet
		tests/functional/test_install.py::test_install_editable_with_prefix_setup_cfg
		tests/functional/test_install.py::test_editable_install__local_dir_no_setup_py_with_pyproject
		tests/functional/test_install.py::test_editable_install__local_dir_setup_requires_with_pyproject
	)

	[[ ${EPYTHON} == python3.10 ]] && EPYTEST_DESELECT+=(
		tests/lib/test_lib.py::test_correct_pip_version
		# uses vendored packaging that uses deprecated distutils
		tests/functional/test_warning.py::test_pip_works_with_warnings_as_errors
	)

	if ! has_version "dev-python/cryptography[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/functional/test_install.py::test_install_sends_client_cert
			tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		)
	fi

	distutils_install_for_testing
	pushd "${WORKDIR}/virtualenv-${VENV_PV}" >/dev/null || die
	distutils_install_for_testing
	popd >/dev/null || die

	local -x GENTOO_PIP_TESTING=1 \
		PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib:${BUILD_DIR}/lib"
	epytest -m "not network"
}

python_install_all() {
	# Prevent dbus auto-launch
	# https://bugs.gentoo.org/692178
	export DBUS_SESSION_BUS_ADDRESS="disabled:"

	local DOCS=( AUTHORS.txt docs/html/**/*.rst )
	distutils-r1_python_install_all

	COMPLETION="${T}"/completion.tmp

	# 'pip completion' command embeds full $0 into completion script, which confuses
	# 'complete' and causes QA warning when running as "${PYTHON} -m pip".
	# This trick sets correct $0 while still calling just installed pip.
	local pipcmd='import sys; sys.argv[0] = "pip"; from pip._internal.cli.main import main; sys.exit(main())'

	${PYTHON} -c "${pipcmd}" completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}

	${PYTHON} -c "${pipcmd}" completion --zsh > "${COMPLETION}" || die
	insinto /usr/share/zsh/site-functions
	newins "${COMPLETION}" _pip
}

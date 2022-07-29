# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{8..10} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_11 pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1 multiprocessing

# setuptools & wheel .whl files are required for testing,
# the exact version is not very important.
SETUPTOOLS_WHL="setuptools-62.3.2-py3-none-any.whl"
WHEEL_WHL="wheel-0.36.2-py2.py3-none-any.whl"
# upstream still requires virtualenv-16 for testing, we are now fetching
# it directly to avoid blockers with virtualenv-20
VENV_PV=16.7.12

DESCRIPTION="The PyPA recommended tool for installing Python packages"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/
"
SRC_URI="
	https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
	test? (
		https://files.pythonhosted.org/packages/py3/s/setuptools/${SETUPTOOLS_WHL}
		https://files.pythonhosted.org/packages/py2.py3/w/wheel/${WHEEL_WHL}
		https://github.com/pypa/virtualenv/archive/${VENV_PV}.tar.gz
			-> virtualenv-${VENV_PV}.gh.tar.gz
	)
"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"
IUSE="vanilla"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/pretend[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/scripttest[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			dev-python/werkzeug[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			!alpha? ( !hppa? ( !ia64? (
				dev-python/cryptography[${PYTHON_USEDEP}]
			) ) )
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/pip-22.2.1-no-coverage.patch"
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
		einfo "Skipping tests on ${EPYTHON} since virtualenv-16 is broken"
		return 0
	fi

	local EPYTEST_DESELECT=(
		tests/functional/test_inspect.py::test_inspect_basic
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_list.py::test_multiple_exclude_and_normalization
		# Internet
		tests/functional/test_install.py::test_install_dry_run
		tests/functional/test_install.py::test_install_editable_with_prefix_setup_cfg
		tests/functional/test_install.py::test_editable_install__local_dir_no_setup_py_with_pyproject
		tests/functional/test_install.py::test_editable_install__local_dir_setup_requires_with_pyproject
	)

	if ! has_version "dev-python/cryptography[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/functional/test_install.py::test_install_sends_client_cert
			tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		)
	fi

	local -x GENTOO_PIP_TESTING=1
	local -x PYTHONPATH="${WORKDIR}/virtualenv-${VENV_PV}"
	local -x SETUPTOOLS_USE_DISTUTILS=stdlib
	local -x PIP_DISABLE_PIP_VERSION_CHECK=1
	epytest -m "not network" -n "$(makeopts_jobs)"
}

python_install_all() {
	local DOCS=( AUTHORS.txt docs/html/**/*.rst )
	distutils-r1_python_install_all

	newbashcomp completion.bash pip

	insinto /usr/share/zsh/site-functions
	newins completion.zsh _pip
}

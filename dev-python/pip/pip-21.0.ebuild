# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1

# setuptools & wheel .whl files are required for testing,
# the exact version is not very important.
SETUPTOOLS_WHL="setuptools-51.3.3-py3-none-any.whl"
WHEEL_WHL="wheel-0.36.2-py2.py3-none-any.whl"

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
	)
"
# PyPI archive does not have tests, so we need to download from GitHub.

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
SLOT="0"
IUSE="test -vanilla"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/csv23[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		<dev-python/virtualenv-20[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-19.3-disable-version-check.patch"
		"${FILESDIR}/${PN}-21.0-no-coverage.patch"
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

	local deselect=(
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_list.py::test_multiple_exclude_and_normalization
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-download]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-install]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-list]'
		'tests/unit/test_commands.py::test_index_group_handle_pip_version_check[False-False-True-wheel]'
	)

	distutils_install_for_testing --via-root

	local -x GENTOO_PIP_TESTING=1 \
		PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib:${BUILD_DIR}/lib"

	pytest -vv ${deselect[@]/#/--deselect } -m "not network" ||
		die "Tests fail with ${EPYTHON}"
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
	local pipcmd='import sys; sys.argv[0] = "pip"; import pip.__main__; sys.exit(pip.__main__._main())'

	${PYTHON} -c "${pipcmd}" completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}

	${PYTHON} -c "${pipcmd}" completion --zsh > "${COMPLETION}" || die
	insinto /usr/share/zsh/site-functions
	newins "${COMPLETION}" _pip
}

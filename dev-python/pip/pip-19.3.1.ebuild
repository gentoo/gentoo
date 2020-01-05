# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1 multiprocessing

SETUPTOOLS_PV="41.4.0"
WHEEL_PV="0.33.6"

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="https://pip.pypa.io/ https://pypi.org/project/pip/ https://github.com/pypa/pip/"
SRC_URI="
	https://github.com/pypa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://files.pythonhosted.org/packages/py2.py3/s/setuptools/setuptools-${SETUPTOOLS_PV}-py2.py3-none-any.whl
		https://files.pythonhosted.org/packages/py2.py3/w/wheel/wheel-${WHEEL_PV}-py2.py3-none-any.whl
	)
"
# PyPI archive does not have tests, so we need to download from GitHub.
# setuptools & wheel .whl files are required for testing, exact version is not very important.

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test -vanilla"

# disable-system-install patch breaks tests
RESTRICT="!vanilla? ( test ) !test? ( test )"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		<dev-python/pytest-4[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		<dev-python/pytest-rerunfailures-7.0[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		<dev-python/pytest-xdist-1.28.0[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-19.3-disable-version-check.patch"
	)
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/pip-19.1-disable-system-install.patch" )
	fi
	distutils-r1_python_prepare_all

	if use test; then
		mkdir tests/data/common_wheels/
		cp "${DISTDIR}"/setuptools-${SETUPTOOLS_PV}-py2.py3-none-any.whl tests/data/common_wheels/ || die
		cp "${DISTDIR}"/wheel-${WHEEL_PV}-py2.py3-none-any.whl tests/data/common_wheels/ || die
	fi
}

python_test () {
	# pip test suite likes to test installed version of pip, both the module and the executable.
	# Here we install it into a temporary dir and add to PATHs in a subshell.
	EPYTHON_ROOT="${T}/${EPYTHON}_root"
	esetup.py install --root "${EPYTHON_ROOT}"

	if [[ ${EPYTHON} == python2* ]]; then
		# These tests just fail on Python 2.
		EXCLUDE_TESTS=( or pep518_uses_build_env or install_package_with_root or install_editable_with_prefix
			or install_from_current_directory_into_usersite or install_user_wheel
			or uninstall_from_usersite_with_dist_in_global_site
			or uninstall_editable_from_usersite
			or build_env_isolation
		)
	fi

	(
		export PATH="${EPYTHON_ROOT}/usr/bin:$PATH"
		export PYTHONPATH="${EPYTHON_ROOT}/$(python_get_sitedir)"

		# Disable VCS and network tests.
		# version_check tests are excluded since we explicitly disable this feature entirely.
		# uninstall test just fails, likely because of our test environment setup.
		python -m pytest \
			-n $(makeopts_jobs) \
			--timeout 300 \
			-k "not (svn or git or bazaar or mercurial or version_check or uninstall_non_local_distutils ${EXCLUDE_TESTS[*]})" \
			-m "not network" \
			|| die
	)
}

python_install_all() {
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

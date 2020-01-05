# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
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
KEYWORDS="~amd64 ~arm64 ~sparc ~x86"
SLOT="0"
IUSE="test -vanilla"

# disable-system-install patch breaks tests
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-19.3-disable-version-check.patch"

		# these are from upstream git
		"${FILESDIR}/pip-19.3.1-network-tests.patch"
	)
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/pip-19.3.1-r2-disable-system-install.patch" )
	fi
	distutils-r1_python_prepare_all

	if use test; then
		mkdir tests/data/common_wheels/ || die
		cp "${DISTDIR}"/setuptools-${SETUPTOOLS_PV}-py2.py3-none-any.whl \
			tests/data/common_wheels/ || die

		cp "${DISTDIR}"/wheel-${WHEEL_PV}-py2.py3-none-any.whl \
			tests/data/common_wheels/ || die
	fi
}

python_test() {
	if [[ ${EPYTHON} == pypy* ]]; then
		ewarn "Skipping tests on ${EPYTHON} since they are very broken"
		return 0
	fi

	local -a exclude_tests

	# these will be built in to an expression passed to pytest to exclude
	exclude_tests=(
		git
		svn
		bazaar
		mercurial
		version_check
		uninstall_non_local_distutils
		pep518_uses_build_env
		install_package_with_root
		install_editable_with_prefix
		install_user_wheel
		install_from_current_directory_into_usersite
		uninstall_editable_from_usersite
		uninstall_from_usersite_with_dist_in_global_site
		build_env_isolation
	)

	distutils_install_for_testing

	# generate the expression to exclude failing tests
	local exclude_expr
	printf -v exclude_expr "or %s " "${exclude_tests[@]}" || die
	exclude_expr="not (${exclude_expr#or })" || die

	local -x GENTOO_PIP_TESTING=1 \
		PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib:${BUILD_DIR}/lib"

	pytest -vv \
		-k "${exclude_expr}" \
		-m "not network" \
		|| die "Tests fail with ${EPYTHON}"
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

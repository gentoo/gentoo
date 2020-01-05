# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1 multiprocessing

SETUPTOOLS_PV="41.0.1"
WHEEL_PV="0.33.1"

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
KEYWORDS="amd64 x86"
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
		"${FILESDIR}/${PN}-19.1-disable-version-check.patch"
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
	# Exclude tests that fail for some reason. Some of these failures may be Gentoo-specific.
	python -m pytest \
		-n $(makeopts_jobs) \
		--timeout 300 \
		-k "not (svn or git or bazaar or mercurial or test_pep518_uses_build_env or test_install_package_with_root or test_install_editable_with_prefix or install_from_user or install_user_conflict or upgrade_user_conflict or build_env_isolation or config_file_venv_option or get_legacy_build_wheel or install_user_wheel or uninstall_non_local_distutils or install_from_current_directory_into_usersite or uninstall_editable_from_usersite)" \
		-m "not network" \
		|| die
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

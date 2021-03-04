# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# Set to 'manual' to avoid triggering install QA check
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multiprocessing

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/jaraco-envs[${PYTHON_USEDEP}]
		>=dev-python/jaraco-path-3.2.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
		dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst )

python_test() {
	distutils_install_for_testing --via-root
	local deselect=(
		# network
		'setuptools/tests/test_virtualenv.py::test_pip_upgrade_from_source[None]'
		setuptools/tests/test_distutils_adoption.py
		# TODO
		setuptools/tests/test_easy_install.py::TestSetupRequires::test_setup_requires_with_allow_hosts
		# this one's unhappy about pytest-xdist but one test is not worth
		# losing the speed gain
		setuptools/tests/test_build_meta.py::TestBuildMetaBackend::test_build_sdist_relative_path_import
	)

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" pytest -vv ${deselect[@]/#/--deselect } \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" \
		setuptools || die "Tests failed under ${EPYTHON}"
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

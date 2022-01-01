# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# Set to 'manual' to avoid triggering install QA check
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{7..10} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multiprocessing

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/jaraco-envs[${PYTHON_USEDEP}]
			>=dev-python/jaraco-path-3.2.0[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
			dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		' python3_{7..9} pypy3)
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
	' python3_{7..9} pypy3)"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst )

python_test() {
	# temporarily skipped, until we port all test deps
	[[ ${EPYTHON} == python3.10 ]] && continue

	distutils_install_for_testing --via-root
	local deselect=(
		# network
		'setuptools/tests/test_virtualenv.py::test_pip_upgrade_from_source[None]'
		setuptools/tests/test_distutils_adoption.py
		# TODO
		setuptools/tests/test_easy_install.py::TestSetupRequires::test_setup_requires_with_allow_hosts
	)
	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		setuptools/tests/test_develop.py::TestDevelop::test_2to3_user_mode
	)

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" epytest ${deselect[@]/#/--deselect } \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" \
		setuptools
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

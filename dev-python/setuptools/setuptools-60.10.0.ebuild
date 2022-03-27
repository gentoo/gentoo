# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multiprocessing

CPY_PATCHSET="python-gentoo-patches-3.10.0_p1"
DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~floppym/python/${CPY_PATCHSET}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/appdirs-1.4.4-r2[${PYTHON_USEDEP}]
	>=dev-python/jaraco-text-3.7.0-r1[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-8.12.0-r1[${PYTHON_USEDEP}]
	dev-python/nspektr[${PYTHON_USEDEP}]
	>=dev-python/ordered-set-4.0.2-r1[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3-r2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-4.10.1-r1[${PYTHON_USEDEP}]
	' python3_{8,9} pypy3)
	$(python_gen_cond_dep '
		>=dev-python/importlib_resources-5.4.0-r3[${PYTHON_USEDEP}]
	' python3_8 pypy3)
"
BDEPEND="
	${RDEPEND}
	>=dev-python/wheel-0.37.1-r1[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			dev-python/build[${PYTHON_USEDEP}]
			>=dev-python/filelock-3.4.0[${PYTHON_USEDEP}]
			>=dev-python/jaraco-envs-2.2[${PYTHON_USEDEP}]
			>=dev-python/jaraco-path-3.2.0[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			dev-python/pip-run[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
			dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/tomli[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		' python3_{8..10} pypy3)
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

DOCS=( {CHANGES,README}.rst )

src_prepare() {
	# remove bundled dependencies, setuptools will switch to system deps
	# automatically
	rm -r */_vendor || die

	# remove the ugly */extern hack that breaks on unvendored deps
	rm -r */extern || die
	find -name '*.py' -exec sed \
		-e 's:from \w*[.]\+extern ::' -e 's:\w*[.]\+extern[.]::' \
		-i {} + || die

	# apply distutils patches to the bundled distutils
	pushd setuptools/_distutils >/dev/null || die
	# TODO: distutils C++ patch?
	eapply -p3 "${WORKDIR}/${CPY_PATCHSET}/0006-distutils-make-OO-enable-both-opt-1-and-opt-2-optimi.patch"
	popd >/dev/null || die

	distutils-r1_src_prepare
}

python_test() {
	local -x SETUPTOOLS_USE_DISTUTILS=stdlib

	# keep in sync with python_gen_cond_dep above!
	has "${EPYTHON}" python3.{8..10} pypy3 || continue

	local EPYTEST_DESELECT=(
		# network
		# TODO: see if PRE_BUILT_SETUPTOOLS_* helps
		setuptools/tests/integration/test_pip_install_sdist.py::test_install_sdist
		setuptools/tests/test_distutils_adoption.py
		setuptools/tests/test_virtualenv.py::test_clean_env_install
		setuptools/tests/test_virtualenv.py::test_no_missing_dependencies
		'setuptools/tests/test_virtualenv.py::test_pip_upgrade_from_source[None]'
		setuptools/tests/test_virtualenv.py::test_test_command_install_requirements
		setuptools/tests/test_setuptools.py::test_its_own_wheel_does_not_contain_tests
		# unhappy with pytest-xdist?
		setuptools/tests/test_easy_install.py::TestUserInstallTest::test_local_index
		# TODO
		setuptools/tests/test_easy_install.py::TestSetupRequires::test_setup_requires_with_allow_hosts
		setuptools/tests/test_test.py::test_tests_are_run_once
	)

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" epytest \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" setuptools
}

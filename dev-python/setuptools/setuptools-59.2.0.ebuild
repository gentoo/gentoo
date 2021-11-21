# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

# Set to 'manual' to avoid triggering install QA check
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multiprocessing

CPY_PATCHSET="python-gentoo-patches-3.10.0rc1"
DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/python/${CPY_PATCHSET}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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
		' python3_{8..10} pypy3)
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst )

src_prepare() {
	# apply distutils patches to the bundled distutils
	pushd setuptools/_distutils >/dev/null || die
	# TODO: distutils C++ patch?
	eapply -p3 "${WORKDIR}/${CPY_PATCHSET}/0006-distutils-make-OO-enable-both-opt-1-and-opt-2-optimi.patch"
	popd >/dev/null || die

	distutils-r1_src_prepare
}

python_test() {
	# keep in sync with python_gen_cond_dep above!
	has "${EPYTHON}" python3.{8..10} pypy3 || continue

	distutils_install_for_testing
	local EPYTEST_DESELECT=(
		# network
		setuptools/tests/test_distutils_adoption.py
		'setuptools/tests/test_virtualenv.py::test_pip_upgrade_from_source[None]'
		# unhappy with pytest-xdist?
		setuptools/tests/test_easy_install.py::TestUserInstallTest::test_local_index
		# TODO
		setuptools/tests/test_easy_install.py::TestSetupRequires::test_setup_requires_with_allow_hosts
	)

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" epytest \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" setuptools
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

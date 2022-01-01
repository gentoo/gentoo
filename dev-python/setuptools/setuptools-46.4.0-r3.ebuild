# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# Set to 'manual' to avoid triggering install QA check
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/unzip
	test? (
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			>=dev-python/pytest-3.7.0[${PYTHON_USEDEP}]
			dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
			dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		' -3)
	)
"
# installing plugins apparently breaks stuff at runtime, so let's pull
# it early
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
	' -3)"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

python_prepare_all() {
	# silence the py2 warning that is awfully verbose and breaks some
	# packages by adding unexpected output
	# (also, we know!)
	sed -i -e '/py2_warn/d' pkg_resources/__init__.py || die

	# disable tests requiring a network connection
	rm setuptools/tests/test_packageindex.py || die

	# don't run integration tests
	rm setuptools/tests/test_integration.py || die

	# xpass-es for me on py3
	sed -e '/xfail.*710/s:(:(six.PY2, :' \
		-i setuptools/tests/test_archive_util.py || die

	# avoid pointless dep on flake8
	sed -i -e 's:--flake8::' pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	if ! python_is_python3; then
		einfo "Tests are skipped on py2 to untangle deps"
		return
	fi

	distutils_install_for_testing
	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" pytest -vv ${PN} || die "Tests failed under ${EPYTHON}"
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/pypa/setuptools.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Temporary hack to avoid py38 keywording hell.  Please remove when
# the test deps all have py38.  Also setuptools' test pass with py38,
# so you need to hack them all in locally before bumping and test.
TEST_USEDEP=$(python_gen_usedep python2_7 python3_{5,6,7} pypy{,3})
BDEPEND="
	app-arch/unzip
	test? (
		dev-python/mock[${TEST_USEDEP}]
		dev-python/pip[${TEST_USEDEP}]
		>=dev-python/pytest-3.7.0[${TEST_USEDEP}]
		dev-python/pytest-fixture-config[${TEST_USEDEP}]
		dev-python/pytest-virtualenv[${TEST_USEDEP}]
		dev-python/wheel[${TEST_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

PATCHES=(
	# fix regression introduced by reinventing deprecated 'imp'
	# https://github.com/pypa/setuptools/pull/1905
	"${FILESDIR}"/setuptools-42.0.0-imp-fix.patch
)

python_prepare_all() {
	if [[ ${PV} == "9999" ]]; then
		python_setup
		${EPYTHON} bootstrap.py || die
	fi

	# disable tests requiring a network connection
	rm setuptools/tests/test_packageindex.py || die

	# don't run integration tests
	rm setuptools/tests/test_integration.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if [[ ${EPYTHON} == python3.8 ]]; then
		if [[ ${PV} != 42.0.1 ]]; then
			eerror "Please disable py38 hacks and test locally, then update this."
			die "Python 3.8 support untested for ${PV}"
		fi
		einfo "Skipping testing on ${EPYTHON} due to unkeyworded deps"
		return
	fi

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" pytest -vv ${PN} || die "Tests failed under ${EPYTHON}"
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

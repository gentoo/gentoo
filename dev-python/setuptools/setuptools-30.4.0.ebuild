# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/pypa/setuptools.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.python.org/pypi/setuptools"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=""
#	>=dev-python/packaging-16.4[${PYTHON_USEDEP}]
#	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
#	"
DEPEND="${RDEPEND}
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
#	>=dev-python/pyparsing-2.0.6[${PYTHON_USEDEP}]
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

python_prepare_all() {
	if [[ ${PV} == "9999" ]]; then
		python_setup
		${EPYTHON} bootstrap.py || die
	fi

	# rm -r ./pkg_resources/_vendor || die
	# disable tests requiring a network connection
	rm setuptools/tests/test_packageindex.py || die

	# don't run integration tests
	rm setuptools/tests/test_integration.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" py.test --verbose ${PN} || die "Tests failed under ${EPYTHON}"
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-r1_python_install
}

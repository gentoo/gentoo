# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1 mercurial

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://pypi.python.org/pypi/setuptools"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/pypa/setuptools"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=""
#	>=dev-python/packaging-16.4[${PYTHON_USEDEP}]
#	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
#	"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
#	>=dev-python/pyparsing-2.0.6[${PYTHON_USEDEP}]
PDEPEND="
	>=dev-python/certifi-2016.8.8[${PYTHON_USEDEP}]"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( README.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

python_prepare_all() {
#	rm -r ./pkg_resources/_vendor || die
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

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="http://www.logilab.org/project/logilab-astng https://pypi.python.org/pypi/logilab-astng"
SRC_URI="ftp://ftp.logilab.org/pub/astng/logilab-${P}.tar.gz mirror://pypi/l/logilab-astng/logilab-${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"
IUSE="test"

# 1.2.2-r1 for namespace files
RDEPEND=">=dev-python/logilab-common-1.2.2-r1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/egenix-mx-base-3.0.0[$(python_gen_usedep 'python2*')] )"

S="${WORKDIR}/logilab-${P}"
RESTRICT="test"		# erroneous failures

# a wit; pypy reports astng modules differently
PATCHES=( "${FILESDIR}"/pypy-test.patch )

python_test() {
	distutils_install_for_testing
	# test target needs unpacked test directories, doesn't like binary egg
	esetup.py install_lib --install-dir="${TEST_DIR}"/lib
	#https://bitbucket.org/logilab/astroid/issue/1/test-suite-fails-in-0243-under-py32-pypy
	# Make sure that the tests use correct modules.
	cd "${TEST_DIR}"/lib || die
	pytest -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	rm "${D}$(python_get_sitedir)/logilab/__init__.py" || die
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}

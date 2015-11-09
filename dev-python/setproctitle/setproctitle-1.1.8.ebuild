# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="https://code.google.com/p/py-setproctitle/ https://pypi.python.org/pypi/setproctitle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
# on <py2.7 the test suite uses SkipTest from nose,
# so we need to run it using nose.
DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

DOCS=( HISTORY.rst README.rst )

python_prepare_all() {
	sed -i -e "/pyrun/s:%s'.*):'):" tests/*.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cp -r -l tests "${BUILD_DIR}"/ || die

	if [[ ${EPYTHON} == python3.* ]]; then
		# Notes:
		#   -W is not supported by python3.1
		#   -n causes Python to write into hardlinked files
		2to3 --no-diffs -w "${BUILD_DIR}"/tests/*.py || die
	fi

	cd "${BUILD_DIR}" || die

	# prepare embedded executable
	emake tests/pyrun CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS} $(python-config --cflags)" \
		LDLIBS="${LDLIBS} $(python-config --libs)"

	nosetests || die "Tests fail with ${EPYTHON}"
}

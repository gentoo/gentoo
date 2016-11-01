# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# pypy doesn't get started in test run. Still required by www-servers/gunicorn
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="https://github.com/dvarrazzo/py-setproctitle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
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

	if [[ ${EPYTHON} =~ pypy ]]; then
		# The suite via the Makefile appears to not cater to pypy
		return
	else
		CPPFLAGS="${CPPFLAGS} $(python_get_CFLAGS)"
		LDLIBS="$(python_get_LIBS)"
	fi

	# prepare embedded executable
	emake tests/pyrun CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		LDLIBS="${LDLIBS}"

	nosetests --verbose || die "Tests fail with ${EPYTHON}"
}

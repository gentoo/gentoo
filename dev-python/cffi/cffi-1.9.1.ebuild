# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# DO NOT ADD pypy to PYTHON_COMPAT
# pypy bundles a modified version of cffi. Use python_gen_cond_dep instead.
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Foreign Function Interface for Python calling C code"
HOMEPAGE="http://cffi.readthedocs.org/ https://pypi.python.org/pypi/cffi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x64-cygwin ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="doc test"

RDEPEND="
	virtual/libffi
	dev-python/pycparser[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )"

# Avoid race on _configtest.c (distutils/command/config.py:_gen_temp_sourcefile)
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	einfo "$PYTHONPATH"
	$PYTHON -c "import _cffi_backend as backend" || die
	PYTHONPATH="${PYTHONPATH}" \
	py.test -x -v \
		--ignore testing/test_zintegration.py \
		--ignore testing/embedding \
		c/ testing/ \
		|| die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}

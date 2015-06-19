# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/guppy/guppy-0.1.10-r1.ebuild,v 1.4 2015/03/08 23:49:42 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Guppy-PE -- A Python Programming Environment"
HOMEPAGE="http://guppy-pe.sourceforge.net/ http://pypi.python.org/pypi/guppy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-0.1.9-rm_BrokenTests.patch )

python_prepare_all() {
	sed -e 's:_PyLong_AsScaledDouble:_PyLong_Frexp:' -i src/sets/bitset.c || die
	distutils-r1_python_prepare_all
}

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" setup.py build install --home="${T}/test-${EPYTHON}" \
		|| die "Installation of tests failed"
	pushd "${T}/test-${EPYTHON}/lib/python" > /dev/null
	"${PYTHON}" guppy/heapy/test/test_all.py || die "tests failed"
	popd > /dev/null
}

python_install_all() {
	# leave the html docs for install as the setup.py dictates but rm if set by IUSE doc
	if use doc; then
		local HTML_DOCS=( guppy/doc/. )
		find "${D}$(python_get_sitedir)" -name doc | xargs rm -rf
	fi
	distutils-r1_python_install_all
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# py2.5 dropped; Test file reveals py2.5 can't support a core file
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="http://code.google.com/p/pylockfile/ http://pypi.python.org/pypi/lockfile http://smontanaro.dyndns.org/python/"
SRC_URI="http://pylockfile.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ~sparc x86"
IUSE="doc test"

DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( ACKS README RELEASE-NOTES )

PATCHES=( "${FILESDIR}"/py3-support.patch )

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		emake -C doc html || die "Generation of documentation failed"
	fi
}

python_test() {
	# "${PYTHON}" test/test_lockfile.py yeilds no informative coverage output
	nosetests || die "test_lockfile failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/.build/html/. )
	distutils-r1_python_install_all
}

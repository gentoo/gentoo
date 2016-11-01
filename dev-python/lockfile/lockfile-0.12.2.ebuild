# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="https://launchpad.net/pylockfile https://pypi.python.org/pypi/lockfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

DEPEND="
	>dev-python/pbr-1.8[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( ACKS AUTHORS ChangeLog README.rst RELEASE-NOTES )

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		emake -C doc/source html || die "Generation of documentation failed"
	fi
}

python_test() {
	# "${PYTHON}" test/test_lockfile.py yeilds no informative coverage output
	nosetests --verbose || die "test_lockfile failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/.build/html/. )
	distutils-r1_python_install_all
}

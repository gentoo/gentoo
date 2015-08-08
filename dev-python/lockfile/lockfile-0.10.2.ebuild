# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="http://launchpad.net/pylockfile http://pypi.python.org/pypi/lockfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc test"

DEPEND="dev-python/pbr[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( ACKS README RELEASE-NOTES )

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		emake -C doc/source html || die "Generation of documentation failed"
	fi
}

python_test() {
	# "${PYTHON}" test/test_lockfile.py yeilds no informative coverage output
	nosetests || die "test_lockfile failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/.build/html/. )
	distutils-r1_python_install_all
}

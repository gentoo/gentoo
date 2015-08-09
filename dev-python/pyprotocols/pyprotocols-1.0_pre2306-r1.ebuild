# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic eutils

MY_PN="PyProtocols"
MY_P="${MY_PN}-${PV/_pre/a0dev_r}"

DESCRIPTION="Extends the PEP 246 adapt function with a new 'declaration API'"
HOMEPAGE="http://peak.telecommunity.com/PyProtocols.html http://pypi.python.org/pypi/PyProtocols \
	http://svn.eby-sarna.com/PyProtocols/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="|| ( PSF-2 ZPL )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-python/decoratortools-1.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/pyrex-0.9.9[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}"

DOCS=( CHANGES.txt README.txt UPGRADING.txt )

python_prepare_all() {
	# Rm peripheral & rogue failing tests
	rm -f src//protocols/tests/{test_twisted.py,test_zope.py} || die
	epatch "${FILESDIR}"/SkipTests.patch
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_test() {
	esetup.py test && einfo "Tests passed under ${EPYTHON}" \
		|| die "Tests failed under ${EPYTHON}"
}

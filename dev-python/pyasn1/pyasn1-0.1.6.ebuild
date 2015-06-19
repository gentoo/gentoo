# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyasn1/pyasn1-0.1.6.ebuild,v 1.18 2015/04/08 08:05:12 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="ASN.1 library for Python"
HOMEPAGE="http://pyasn1.sourceforge.net/ http://pypi.python.org/pypi/pyasn1"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" test/suite.py || die "Tests fail with ${EPYTHON}"
}

src_install() {
	local HTML_DOCS=( doc/pyasn1-tutorial.html )
	use doc && HTML_DOCS=( doc/. )

	distutils-r1_src_install
}

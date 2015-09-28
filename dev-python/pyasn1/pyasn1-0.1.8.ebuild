# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="ASN.1 library for Python"
HOMEPAGE="http://pyasn1.sourceforge.net/ https://pypi.python.org/pypi/pyasn1"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
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

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MY_PN="TwistedSNMP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SNMP protocols and APIs for use with the Twisted networking framework"
HOMEPAGE="http://twistedsnmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples test"

RDEPEND="=dev-python/pysnmp-3*[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-1.3[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND} )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_prepare_all() {
	# Disable broken test.
	sed -e "s/test_tableGetWithStart/_&/" -i test/test_get.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test/test.py || die "tests failed"
}

src_install() {
	local HTML_DOCS=( doc/index.html )
	use examples && local EXAMPLES=( doc/examples/. )
	distutils-r1_src_install
	insinto /usr/share/doc/${PF}/html/style/
	doins doc/style/sitestyle.css
}

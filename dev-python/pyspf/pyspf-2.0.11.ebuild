# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ipv6?"
inherit distutils-r1

DESCRIPTION="Python implementation of the Sender Policy Framework (SPF) protocol"
HOMEPAGE="http://pypi.python.org/pypi/pyspf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 test"

# >=python-3.3 comes with the built-in ipaddress module
RDEPEND="dev-python/authres[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/ipaddr-2.1.10[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/pydns:2[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/pydns:3[${PYTHON_USEDEP}]' 'python3*')"

DEPEND="test? ( ${RDEPEND}
	dev-python/pyyaml[${PYTHON_USEDEP}] )"

REQUIRED_USE="test? ( ipv6 )"

python_test() {
	pushd test &> /dev/null
	"${PYTHON}" testspf.py || die
	popd &> /dev/null
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/imapclient/imapclient-0.12.ebuild,v 1.3 2015/03/08 23:50:41 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="IMAPClient"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="easy-to-use, pythonic, and complete IMAP client library"
HOMEPAGE="http://imapclient.freshfoo.com/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy) )"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	# use system setuptools
	sed -i '/use_setuptools/d' setup.py || die

	# drop explicit mock version test dep
	sed -i "/tests_require/s:'mock==.\+':'mock':" setup.py || die

	# use system six library. patch proven less preferable to use of sed (< maintenance)
	# but a copy of the working hunks from prior version works fine for now.
	rm imapclient/six.py || die
	epatch "${FILESDIR}"/0.12-tests.patch
	sed -e 's:from .six:from six:g' \
		-e 's:from . import six:import six:g' \
		-i ${PN}/*.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover || die "tests failed under ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	# don't install examples and tests in module dir
	rm -r "${D}"$(python_get_sitedir)/imapclient/{examples,test} || die
}

python_install_all() {
#	local DOCS=( AUTHORS HACKING.rst NEWS.rst README.rst THANKS )
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
	use examples && dodoc -r ${PN}/examples
}

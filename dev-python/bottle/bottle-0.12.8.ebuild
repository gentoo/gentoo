# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bottle/bottle-0.12.8.ebuild,v 1.1 2015/02/03 02:26:39 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="http://pypi.python.org/pypi/bottle http://bottlepy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

python_prepare_all() {
	sed -i -e '/scripts/d' setup.py || die

	# Remove test file requring connection to network
	rm ./test/test_server.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# A few odd fails in the suite under pypy
	# https://github.com/bottlepy/bottle/issues/714
	"${PYTHON}" test/testall.py || die "tests failed under ${EPYTHON}"
}

pkg_postinst() {
	elog "Due to problems with bottle.py being in /usr/bin (see bug #474874)"
	elog "we do as most other distros and do not install the script anymore."
	elog "If you do want/have to call it directly rather than through your app,"
	elog "please use the following instead:"
	elog '  `python -m bottle`'
}

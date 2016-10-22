# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1 eutils

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="https://pypi.python.org/pypi/bottle http://bottlepy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( dev-python/mako[$(python_gen_usedep 'python*')] )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.8-py3.5-backport.patch
)

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
	optfeature "Templating support" dev-python/mako
	elog "Due to problems with bottle.py being in /usr/bin (see bug #474874)"
	elog "we do as most other distros and do not install the script anymore."
	elog "If you do want/have to call it directly rather than through your app,"
	elog "please use the following instead:"
	elog '  `python -m bottle`'
}

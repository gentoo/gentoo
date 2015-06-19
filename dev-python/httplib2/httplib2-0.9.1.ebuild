# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/httplib2/httplib2-0.9.1.ebuild,v 1.1 2015/04/14 07:41:15 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="http://pypi.python.org/pypi/httplib2 https://github.com/jcgregorio/httplib2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# tests connect to random remote sites
RESTRICT="test"

python_test() {
	if [[ ${EPYTHON} == python2.7 ]] ; then
		cd python2 || die
	else
		cd python3 || die
	fi

	"${PYTHON}" httplib2test.py || die
}

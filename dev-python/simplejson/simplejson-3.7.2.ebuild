# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/simplejson/simplejson-3.7.2.ebuild,v 1.2 2015/06/26 14:29:55 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Simple, fast, extensible JSON encoder/decoder for Python"
HOMEPAGE="http://undefined.org/python/#simplejson http://pypi.python.org/pypi/simplejson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT AFL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.rst CHANGES.txt )

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

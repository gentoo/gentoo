# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Stateful programmatic web browsing in Python"
HOMEPAGE="http://wwwsearch.sourceforge.net/mechanize/ https://pypi.python.org/pypi/mechanize"
SRC_URI="http://wwwsearch.sourceforge.net/${PN}/src/${P}.tar.gz"

LICENSE="|| ( BSD ZPL )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	# Ignore warnings (https://github.com/jjlee/mechanize/issues/issue/13).
	# https://github.com/jjlee/mechanize/issues/66
	"${PYTHON}" -W ignore test.py
}

python_install_all() {
	# Fix some paths.
	sed -e "s:../styles/:styles/:g" -i docs/html/* || die "sed failed"
	if use doc; then
		dohtml -r docs/html/ docs/styles
	fi

	distutils-r1_python_install_all
}

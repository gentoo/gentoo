# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/peppercorn/peppercorn-0.4-r1.ebuild,v 1.4 2015/04/08 08:04:56 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1

DESCRIPTION="A library for converting a token stream into a data structure for use in web form posts"
HOMEPAGE="https://github.com/Pylons/peppercorn http://pypi.python.org/pypi/peppercorn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

# Include COPYRIGHT.txt because the license seems to require it.
DOCS=( CHANGES.txt README.txt COPYRIGHT.txt )

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	# Install only the .rst source, as sphinx processing requires a
	# theme only available from git that contains hardcoded references
	# to files on https://static.pylonsproject.org/ (so the docs would
	# not actually work offline). Install into a "docs" subdirectory
	# so the reference in the README remains correct.
	docinto docs
	dodoc docs/*.rst
}

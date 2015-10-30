# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for python stdlib csv module supporting unicode"
HOMEPAGE="https://pypi.python.org/pypi/unicodecsv https://github.com/jdunck/python-unicodecsv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

# not contained in the release tarball
RESTRICT="test"

python_test() {
	esetup.py test
}

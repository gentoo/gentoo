# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library (fork of cssutils)"
HOMEPAGE="https://pypi.org/project/css-parser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

# Tests fail under network-sandbox.
RESTRICT+=" test"

python_test() {
	esetup.py test || die "tests failed under ${EPYTHON}"
}

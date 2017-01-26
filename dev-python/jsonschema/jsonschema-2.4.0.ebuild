# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="https://pypi.python.org/pypi/jsonschema"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

python_test() {
	"${PYTHON}" -m unittest discover || die "Testing failed with ${EPYTHON}"
}

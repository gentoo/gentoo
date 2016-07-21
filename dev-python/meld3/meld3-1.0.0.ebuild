# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="meld3 is an HTML/XML templating engine"
HOMEPAGE="https://github.com/supervisor/meld3 https://pypi.python.org/pypi/meld3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# tests use a local path.
RESTRICT=test

python_test() {
	PYTHONPATH=. "${PYTHON}" ${PN}/test_${PN}.py || die "Tests failed under ${EPYTHON}"
}

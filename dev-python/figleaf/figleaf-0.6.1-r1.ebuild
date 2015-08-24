# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Code coverage tool"
HOMEPAGE="http://darcs.idyll.org/~t/projects/figleaf/doc/ https://pypi.python.org/pypi/figleaf"
SRC_URI="http://darcs.idyll.org/~t/projects/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

DOCS="doc/*.txt doc/ChangeLog"

python_test() {
	nosetests || die "tests failed under ${EPYTHON}"
}

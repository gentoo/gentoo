# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/columnize/columnize-0.3.5-r1.ebuild,v 1.3 2015/03/08 23:42:18 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Format a simple (i.e. not nested) list into aligned columns"
HOMEPAGE="http://code.google.com/p/pycolumnize/ http://pypi.python.org/pypi/columnize"
SRC_URI="http://pycolumnize.googlecode.com/files/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	nosetests || die "tests failed"
}

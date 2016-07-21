# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Format a simple (i.e. not nested) list into aligned columns"
HOMEPAGE="https://code.google.com/p/pycolumnize/ https://pypi.python.org/pypi/columnize"
SRC_URI="https://pycolumnize.googlecode.com/files/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-nose.patch )

python_test() {
	nosetests || die "tests failed"
}

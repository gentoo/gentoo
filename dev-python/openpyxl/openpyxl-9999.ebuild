# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 mercurial

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="http://openpyxl.readthedocs.org"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/openpyxl/openpyxl"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-python/jdcal[${PYTHON_USEDEP}]
	dev-python/et_xmlfile[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test || die "Testing failed with ${EPYTHON}"
}

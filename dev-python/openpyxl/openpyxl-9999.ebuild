# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/openpyxl/openpyxl-9999.ebuild,v 1.1 2015/05/13 12:50:14 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 mercurial

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="http://openpyxl.readthedocs.org"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/openpyxl/openpyxl"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-python/jdcal[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test || die "Testing failed with ${EPYTHON}"
}

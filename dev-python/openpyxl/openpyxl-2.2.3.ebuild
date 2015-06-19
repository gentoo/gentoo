# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/openpyxl/openpyxl-2.2.3.ebuild,v 1.1 2015/05/26 13:15:28 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="http://openpyxl.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/jdcal[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)"

# tests aren't contained in tarball
RESTRICT="test"

python_test() {
	py.test || die "Testing failed with ${EPYTHON}"
}

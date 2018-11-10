# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Library for developers to extract data from Microsoft Excel (tm) spreadsheet files"
HOMEPAGE="
	http://www.python-excel.org/
	https://github.com/python-excel/xlrd/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.9.3-column.patch )

python_prepare_all() {
	# Remove this if examples get reintroduced
	sed -i -e "s/test_names_demo/_&/" tests/test_open_workbook.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover || die "Test failed with ${EPYTHON}"
}

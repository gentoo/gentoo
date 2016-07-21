# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="https://pypi.python.org/pypi/${PN}/ https://github.com/mstamy2/PyPDF2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

python_test() {
	# https://github.com/mstamy2/PyPDF2/issues/216
	einfo ""; einfo "According to the author, this 1 failed test is an"
	einfo "expected failure meaning the installation of PyPDF2 is working"
	einfo "He plans to update the causative file to see it pass"; einfo ""

	"${PYTHON}" -m unittest Tests.tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( Sample_Code/. )
	distutils-r1_python_install_all
}

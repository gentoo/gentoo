# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyPDF2/PyPDF2-1.24.ebuild,v 1.3 2015/03/08 23:38:15 pacho Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="http://pypi.python.org/pypi/${PN}/ http://mstamy2.github.com/PyPDF2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

python_install_all() {
	use examples && local EXAMPLES=( Sample_Code/. )
	distutils-r1_python_install_all
}

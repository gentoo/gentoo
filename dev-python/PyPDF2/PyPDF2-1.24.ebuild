# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="https://pypi.python.org/pypi/${PN}/ https://mstamy2.github.com/PyPDF2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

python_install_all() {
	use examples && local EXAMPLES=( Sample_Code/. )
	distutils-r1_python_install_all
}

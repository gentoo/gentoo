# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/xhtml2pdf/xhtml2pdf-0.0.6-r1.ebuild,v 1.1 2015/01/03 05:03:06 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PDF generator using HTML and CSS"
HOMEPAGE="http://www.xhtml2pdf.com/ http://pypi.python.org/pypi/xhtml2pdf/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/html5lib[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/PyPDF2[${PYTHON_USEDEP}]
	>=dev-python/reportlab-2.2[${PYTHON_USEDEP}]
	<dev-python/reportlab-3[${PYTHON_USEDEP}]"
# on testing, this version fails under reportlab-3.*
# which was still new and likely untested at time of release; Bug #530134
RDEPEND="${DEPEND}"

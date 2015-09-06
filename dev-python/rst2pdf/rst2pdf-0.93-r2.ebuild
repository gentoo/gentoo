# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="http://rst2pdf.ralsina.com.ar/ https://pypi.python.org/pypi/rst2pdf"
SRC_URI="https://rst2pdf.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ppc ~ppc64 x86"
IUSE="svg"

DEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/pdfrw[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	svg? ( media-gfx/svg2rlg )"
RDEPEND="${DEPEND}"
# >=reportlab-2.6: https://code.google.com/p/rst2pdf/issues/detail?id=474

python_prepare_all() {
	epatch "${FILESDIR}/${P}-fix-logging.patch"
	distutils-r1_python_prepare_all
}

python_install_all() {
	dodoc doc/*.pdf
	doman doc/rst2pdf.1
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "rst2pdf can work with the following packages for additional functionality:"
		elog "   dev-python/sphinx       - versatile documentation creation"
		elog "   dev-python/pythonmagick - image processing with ImageMagick"
		elog "   dev-python/matplotlib   - mathematical formulae"
		elog "It can also use wordaxe for hyphenation, but this package is not"
		elog "available in the portage tree yet. Please refer to the manual"
		elog "installed in /usr/share/doc/${PF}/ for more information."
	fi
}

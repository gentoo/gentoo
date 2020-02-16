# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="http://rst2pdf.ralsina.me/ https://pypi.org/project/rst2pdf/"
SRC_URI="https://github.com/rst2pdf/rst2pdf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86"
IUSE="svg"

DEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pdfrw[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	svg? ( media-gfx/svg2rlg )"
RDEPEND="${DEPEND}"
# >=reportlab-2.6: https://code.google.com/p/rst2pdf/issues/detail?id=474

PATCHES=( "${FILESDIR}/${P}-fix-logging.patch" )

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

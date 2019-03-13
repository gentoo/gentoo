# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 xdg

DESCRIPTION="GUI app that can merge or split pdfs and rotate, crop and rearrange their pages"
HOMEPAGE="https://sourceforge.net/projects/pdfshuffler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( dev-python/PyPDF2 dev-python/pyPdf )
	dev-python/python-poppler"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README TODO AUTHORS )

PATCHES=( "${FILESDIR}"/${PN}-PyPDF2.patch )

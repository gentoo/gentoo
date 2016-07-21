# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime gnome2-utils

DESCRIPTION="GUI app that can merge or split pdfs and rotate, crop and rearrange their pages"
HOMEPAGE="http://sourceforge.net/projects/pdfshuffler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( dev-python/PyPDF2 dev-python/pyPdf )
	dev-python/python-poppler"
RDEPEND="${DEPEND}"

DOCS="ChangeLog README TODO AUTHORS"
PATCHES=( "${FILESDIR}"/${PN}-PyPDF2.patch )

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

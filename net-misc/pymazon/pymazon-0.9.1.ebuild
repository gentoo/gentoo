# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"
inherit eutils distutils fdo-mime

MY_P="Pymazon-${PV}"
DESCRIPTION="Downloader for the Amazon.com MP3 music store"
HOMEPAGE="https://code.google.com/p/pymazon/"
SRC_URI="https://pymazon.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk +qt4"

DEPEND="gtk? ( dev-python/pygtk )
	qt4? ( dev-python/PyQt4 )"
RDEPEND="${DEPEND}
	dev-python/pycrypto"
S="${WORKDIR}/pymazon"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install

	insinto /usr/share/pixmaps
	newins pymazon/resource/icons/download.png pymazon.png

	if ! use gtk && ! use qt4; then
		EXTRA_FIELDS="\nTerminal=true\nNoDisplay=true"
		DEFAULTARGS=" -c"
	fi
	make_desktop_entry "pymazon${DEFAULTARGS}" "Pymazon MP3 Downloader" \
		pymazon "Network;FileTransfer" \
		"MimeType=audio/x-amzxml;${EXTRA_FIELDS}"

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/amz.xml"
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	einfo "To link pymazon with your amazon.com account, visit:"
	einfo "  http://www.amazon.com/gp/dmusic/after_download_manager_install.html"
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

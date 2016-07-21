# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
PYTHON_DEPEND="2"

inherit fdo-mime python

DESCRIPTION="A graphical tool to compare and merge text files"
HOMEPAGE="http://diffuse.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/pygtk"
# file collision, bug #279018
DEPEND="!sci-chemistry/tinker"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs 2 src/usr/bin/diffuse
}

src_install() {
	"$(PYTHON)" install.py \
		--prefix=/usr \
		--files-only \
		--destdir="${D}" \
		|| die "Installation failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}

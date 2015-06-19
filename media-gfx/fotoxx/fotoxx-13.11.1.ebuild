# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fotoxx/fotoxx-13.11.1.ebuild,v 1.4 2013/12/24 12:54:07 ago Exp $

EAPI=4

inherit eutils toolchain-funcs fdo-mime

DESCRIPTION="Program for improving image files made with a digital camera"
HOMEPAGE="http://www.kornelix.com/fotoxx.html"
SRC_URI="http://www.kornelix.com/uploads/1/3/0/3/13035936/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	x11-libs/gtk+:3
	media-libs/libpng
	media-libs/tiff
	media-libs/lcms:2"
RDEPEND="${DEPEND}
	media-libs/exiftool
	media-gfx/ufraw[gtk]
	media-gfx/dcraw
	x11-misc/xdg-utils"

src_prepare() {
	epatch "${FILESDIR}"/${PF}.patch
}

src_compile() {
	tc-export CXX
	emake
}

src_install() {
	# For the Help menu items to work, *.html must be in /usr/share/doc/${PF},
	# and README, changelog, translations, edit-menus, KB-shortcuts must not be compressed
	emake DESTDIR="${D}" install
	newmenu desktop ${PN}.desktop
	rm -f "${D}"/usr/share/doc/${PF}/*.man
	docompress -x /usr/share/doc
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

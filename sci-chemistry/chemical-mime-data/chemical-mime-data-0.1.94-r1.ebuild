# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils fdo-mime

DESCRIPTION="A collection of data files to add support for chemical MIME types"
HOMEPAGE="http://chemical-mime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/-data/}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pkgconfig
		x11-misc/shared-mime-info
		dev-util/intltool
		dev-util/desktop-file-utils
		dev-libs/libxslt
		media-gfx/imagemagick[xml]
		gnome-base/gnome-mime-data"

RDEPEND=""

src_configure() {
	econf --disable-update-database --htmldir=/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	ewarn "You can ignore any 'Unknown media type in type' warnings."
}

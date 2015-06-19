# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffdiaporama/ffdiaporama-1.5.ebuild,v 1.5 2014/05/15 17:10:15 ulm Exp $

EAPI=5

inherit eutils fdo-mime gnome2-utils qt4-r2

DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="http://ffdiaporama.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/${PN}/Archives/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-gfx/exiv2
	media-libs/libsdl[sound]
	media-libs/qimageblitz
	media-libs/taglib
	virtual/ffmpeg[encode]
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )

src_unpack() {
	# S=${WORKDIR} would result in unremoved files in
	# ${WORKDIR}/../build
	mkdir ${P} || die
	cd ${P} || die
	unpack ${A}
}

src_install() {
	qt4-r2_src_install
	doicon -s 32 ffdiaporama.png
}

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

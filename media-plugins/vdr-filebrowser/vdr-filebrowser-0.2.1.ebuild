# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: file manager plugin for moving or renaming files in VDR"
HOMEPAGE="http://vdr.nasenbaeren.net/filebrowser/"
SRC_URI="http://vdr.nasenbaeren.net/filebrowser/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.4.0"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install

	insinto	/etc/vdr/plugins/filebrowser
	doins   "${FILESDIR}"/commands.conf
	doins   "${FILESDIR}"/order.conf
	doins   "${FILESDIR}"/othercommands.conf
	doins   "${FILESDIR}"/sources.conf
}

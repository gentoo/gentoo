# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-sleeptimer/vdr-sleeptimer-0.6.ebuild,v 1.3 2014/01/14 18:46:51 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Sleeptimer"
HOMEPAGE="http://linvdr.org/download/vdr-sleeptimer"
SRC_URI="http://linvdr.org/download/vdr-sleeptimer/${VDRPLUGIN}-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

PATCHES=( "${FILESDIR}/${P}-includes.diff" )

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i sleeptimer.c -e "s:RegisterI18n://RegisterI18n:"
}

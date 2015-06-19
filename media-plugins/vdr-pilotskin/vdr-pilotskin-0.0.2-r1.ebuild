# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pilotskin/vdr-pilotskin-0.0.2-r1.ebuild,v 1.5 2014/01/15 00:41:58 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: fork of vdr-pilot - navigate through channels with skinnable design"
HOMEPAGE="http://vdrwiki.free.fr/vdr/pilotskin/"
SRC_URI="http://vdrwiki.free.fr/vdr/pilotskin/files/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.36"

PATCHES=("${FILESDIR}/${P}-vdr-1.5.diff")

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i pilotskin.c -e "s:RegisterI18n://RegisterI18n:"
	remove_i18n_include pilotskin.c
}

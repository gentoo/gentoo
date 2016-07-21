# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Another way for viewing EPG and zap to channels"
HOMEPAGE="http://famillejacques.free.fr/vdr/"
SRC_URI="http://famillejacques.free.fr/vdr/pilot/${P}.tgz"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.4.1"

src_prepare() {
	vdr-plugin-2_src_prepare

	epatch "${FILESDIR}/${P}-german.diff"
	epatch "${FILESDIR}/${P}-gcc-4.1.diff"

	if has_version ">=media-video/vdr-1.6.0"; then
		epatch "${FILESDIR}/${P}-vdr-1.6.0.diff"
	fi

	sed -i pilot.c -e "s:RegisterI18n://RegisterI18n:"
	vdr_remove_i18n_include pilot.c
}

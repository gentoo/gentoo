# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show content of menu in a shell window"
HOMEPAGE="https://www.tvdr.de/"
SRC_URI="https://md11.it.cx/download/vdr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="~media-video/vdr-2.2.0"

src_prepare() {
	if has_version ">=media-video/vdr-2.4"; then
		einfo "\nvdr-skincurses-2.2.0 needs exactly media-video/vdr-2.2.x"
		einfo "media-plugins/vdr-skincurses is part of the core VDR"
		einfo "To get this plugin in a later version"
		einfo "emerge --unmerge vdr-skincurses"
		einfo "emerge media-video/vdr with use-flag demoplugins\n"
		die "plugin too old for >=media-video/vdr-2.4"
	fi

	vdr-plugin-2_src_prepare
}

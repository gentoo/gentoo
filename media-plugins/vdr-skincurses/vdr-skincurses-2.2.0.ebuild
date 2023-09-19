# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show content of menu in a shell window"
HOMEPAGE="http://www.tvdr.de/"
SRC_URI="mirror://gentoo/${P}.tar.gz
		https://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="~media-video/vdr-2.2.0"

src_prepare() {
	if has_version ">=media-video/vdr-2.4"; then
		einfo "\nvdr-skincurses-2.2.0 needs exact media-video/vdr-2.2.x"
		einfo "media-plugins/vdr-skincurses is part of the core VDR"
		einfo "To get this plugin in a later version"
		einfo "emerge --unmerge vdr-skincurses"
		einfo "emerge media-video/vdr with use-flag demoplugins\n"
		die "plugin to old for >=media-video/vdr-2.4"
	fi

	vdr-plugin-2_src_prepare
}

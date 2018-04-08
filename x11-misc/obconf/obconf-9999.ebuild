# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg-utils git-r3

DESCRIPTION="ObConf is a tool for configuring the Openbox window manager"
HOMEPAGE="http://openbox.org/wiki/ObConf:About"
EGIT_REPO_URI="git://git.openbox.org/dana/obconf.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="x11-libs/gtk+:3
	x11-libs/startup-notification
	=x11-wm/openbox-9999"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

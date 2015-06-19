# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/obconf/obconf-9999.ebuild,v 1.15 2014/08/10 20:03:23 slyfox Exp $

EAPI="2"

WANT_AUTOMAKE="1.9"
inherit autotools fdo-mime git-2

DESCRIPTION="ObConf is a tool for configuring the Openbox window manager"
HOMEPAGE="http://openbox.org/wiki/ObConf:About"
EGIT_REPO_URI="git://git.openbox.org/dana/obconf.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="gnome-base/libglade:2.0
	x11-libs/gtk+:2
	x11-libs/startup-notification
	=x11-wm/openbox-9999"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	eautopoint
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS CHANGELOG README || die "dodoc failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

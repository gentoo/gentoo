# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib xfconf

DESCRIPTION="Audacious and MPD panel plugins"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-xmms-plugin"
SRC_URI="http://www.bilimfeneri.gen.tr/ilgar/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="audacious mpd"

RDEPEND="x11-libs/gtk+:2
	x11-libs/pango
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8
	mpd? ( >=media-libs/libmpd-0.12 )
	audacious? ( >=media-sound/audacious-1.4 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-undeclared_XfceRc.patch )

	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		--disable-static
		--disable-xmms
		$(use_enable audacious)
		$(use_enable mpd)
		)

	DOCS=( AUTHORS ChangeLog README README.developers )
}

src_prepare() {
	echo panel-plugin/mpc.c > po/POTFILES.skip
	echo panel-plugin/popupmenu.c >> po/POTFILES.skip
	xfconf_src_prepare
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-taskmanager/xfce4-taskmanager-1.1.0.ebuild,v 1.5 2015/07/12 09:33:25 jer Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Task Manager"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-taskmanager"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="debug gksu gtk3"

RDEPEND="x11-libs/cairo:=
	gtk3? (
		x11-libs/gtk+:3=
		x11-libs/libwnck:3=
	)
	!gtk3? (
		>=x11-libs/gtk+-2.12:2=
		x11-libs/libwnck:1=
		gksu? ( x11-libs/libgksu:2= )
	)"
# GTK+2 is required unconditionally
# https://bugzilla.xfce.org/show_bug.cgi?id=11819
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	>=x11-libs/gtk+-2.12:2=
	virtual/pkgconfig"
REQUIRED_USE="gksu? ( !gtk3 )"

pkg_setup() {
	XFCONF=(
		--enable-wnck
		$(use_enable gtk3)
		$(use_enable gksu)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}

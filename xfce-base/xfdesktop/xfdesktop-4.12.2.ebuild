# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfdesktop/xfdesktop-4.12.2.ebuild,v 1.8 2015/07/25 12:19:13 pacho Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Desktop manager for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug libnotify +thunar"

# src/xfdesktop-file-utils.c:#if GLIB_CHECK_VERSION (2, 38, 0)
RDEPEND=">=x11-libs/cairo-1.6:=
	>=dev-libs/dbus-glib-0.100:=
	>=dev-libs/glib-2.20:=
	>=x11-libs/gtk+-2.24:2=
	>=x11-libs/libwnck-2.30:1=
	x11-libs/libX11:=
	>=xfce-base/exo-0.8:=
	>=xfce-base/garcon-0.3:=
	>=xfce-base/libxfce4ui-4.11:=
	>=xfce-base/libxfce4util-4.11:=
	>=xfce-base/xfconf-4.10:=
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	thunar? (
		>=dev-libs/glib-2.38:=
		>=xfce-base/thunar-1.6:=[dbus]
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable thunar file-icons)
		$(use_enable thunar thunarx)
		$(use_enable libnotify notifications)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

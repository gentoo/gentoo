# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfce4ui/libxfce4ui-4.12.1-r2.ebuild,v 1.9 2015/07/25 11:49:33 pacho Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Unified widgets and session management libraries for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/libxfce4"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug +gtk3 startup-notification"

RDEPEND=">=dev-libs/glib-2.30:2=
	>=x11-libs/gtk+-2.24:2=
	x11-libs/libX11:=
	x11-libs/libICE:=
	x11-libs/libSM:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfconf-4.12:=
	gtk3? ( >=x11-libs/gtk+-3.2:3= )
	startup-notification? ( x11-libs/startup-notification:= )
	!xfce-base/xfce-utils"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable startup-notification)
		$(use_enable gtk3)
		$(xfconf_use_debug)
		# requires deprecated glade:3 (gladeui-1.0), bug #551296
		--disable-gladeui
		--with-vendor-info=Gentoo
		)

	[[ ${CHOST} == *-darwin* ]] && XFCONF+=( --disable-visibility ) #366857

	DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
}

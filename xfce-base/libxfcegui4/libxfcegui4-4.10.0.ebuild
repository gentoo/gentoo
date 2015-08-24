# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="A compability library for unported Xfce 4.6 plugins (DEPRECATED)"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage http://git.xfce.org/archive/libxfcegui4/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~x64-solaris"
IUSE="glade startup-notification"

RDEPEND="gnome-base/libglade
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-4.10
	<xfce-base/libxfce4util-4.11
	glade? ( dev-util/glade:3 )
	startup-notification? ( x11-libs/startup-notification )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--disable-static
		$(use_enable startup-notification)
		$(use_enable glade gladeui)
		--with-html-dir="${EPREFIX}"/deprecated
		)
}

src_install() {
	xfconf_src_install
	rm -rf "${ED}"/deprecated
}

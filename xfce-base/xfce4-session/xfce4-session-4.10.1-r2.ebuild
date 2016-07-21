# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EAUTORECONF=1
inherit xfconf

DESCRIPTION="A session manager for the Xfce desktop environment"
HOMEPAGE="http://docs.xfce.org/xfce/xfce4-session/start"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug nls systemd upower +xscreensaver"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100
	x11-apps/iceauth
	x11-libs/libSM
	>=x11-libs/libwnck-2.30:1
	x11-libs/libX11
	>=xfce-base/libxfce4util-4.10.1
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/xfconf-4.10
	!xfce-base/xfce-utils
	systemd? ( >=sys-auth/polkit-0.100 )"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xrdb
	nls? ( x11-misc/xdg-user-dirs )
	upower? (
		systemd? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )
		!systemd? ( sys-power/upower-pm-utils )
		)
	xscreensaver? ( || (
		>=x11-misc/xscreensaver-5.26
		gnome-extra/gnome-screensaver
		>=x11-misc/xlockmore-5.43
		x11-misc/slock
		x11-misc/alock[pam]
		) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${P}-alock_support_to_xflock4.patch
		"${FILESDIR}"/${P}-systemd.patch
		)

	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable systemd)
		--with-xsession-prefix="${EPREFIX}"/usr
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS BUGS ChangeLog NEWS README TODO )
}

src_install() {
	xfconf_src_install

	local sessiondir=/etc/X11/Sessions
	echo startxfce4 > "${T}"/Xfce4
	exeinto ${sessiondir}
	doexe "${T}"/Xfce4
	dosym Xfce4 ${sessiondir}/Xfce
}

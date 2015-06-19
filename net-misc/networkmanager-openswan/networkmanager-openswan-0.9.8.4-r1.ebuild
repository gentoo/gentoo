# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-openswan/networkmanager-openswan-0.9.8.4-r1.ebuild,v 1.3 2014/12/19 13:42:40 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit autotools eutils gnome2

DESCRIPTION="NetworkManager Openswan plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

SRC_URI="${SRC_URI} http://dev.gentoo.org/~pacho/gnome/${P}-patches.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-0.9.8:=
	>=dev-libs/dbus-glib-0.74
	|| ( net-misc/openswan net-misc/libreswan )
	gtk? (
		>=x11-libs/gtk+-3.0.0:3
		gnome-base/gnome-keyring
		gnome-base/libgnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	# Apply patches from Fedora, upstream bug #735692
	epatch "${WORKDIR}/${P}-patches"/*.patch
	echo "auth-dialog/nm-openswan-auth-dialog.desktop.in" >> po/POTFILES.in || die
	echo "auth-dialog/nm-openswan-auth-dialog.desktop.in.in" >> po/POTFILES.in || die

	eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		--with-gtkver=3 \
		$(use_with gtk gnome)
}

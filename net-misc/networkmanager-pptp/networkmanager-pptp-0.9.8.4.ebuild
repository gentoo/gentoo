# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit eutils gnome2-utils gnome.org

DESCRIPTION="NetworkManager PPTP plugin"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-0.9.8
	>=dev-libs/dbus-glib-0.74
	net-dialup/ppp
	net-dialup/pptpclient
	gtk? (
		>=x11-libs/gtk+-2.91.4:3
		gnome-base/gnome-keyring
		gnome-base/libgnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	gnome2_disable_deprecation_warning
}

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		--with-gtkver=3 \
		$(use_with gtk gnome)
}

src_install() {
	default
	prune_libtool_files
}

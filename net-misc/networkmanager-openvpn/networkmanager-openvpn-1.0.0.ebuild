# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-openvpn/networkmanager-openvpn-1.0.0.ebuild,v 1.1 2015/01/10 15:24:59 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit eutils gnome2

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk test"

RDEPEND="
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32:2
	>=net-misc/networkmanager-0.9.10:=
	>=net-misc/openvpn-2.1_rc9
	gtk? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.9.0
		>=x11-libs/gtk+-3.4:3
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	# Test will fail if the machine doesn't have a particular locale installed
	# FAIL: (tls-import-data) unexpected 'ca' secret value, upstream bug #742708
	sed '/test_non_utf8_import (plugin, test_dir)/ d' \
		-i properties/tests/test-import-export.c || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome) \
		$(use_with test tests)
}

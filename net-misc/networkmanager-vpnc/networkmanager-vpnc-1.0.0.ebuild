# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-vpnc/networkmanager-vpnc-1.0.0.ebuild,v 1.3 2015/03/15 13:32:01 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager VPNC plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk test"

RDEPEND="
	>=net-misc/networkmanager-0.9.10:=
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32:2
	>=net-misc/vpnc-0.5
	gtk? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.9.0
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	# Test will fail if the machine doesn't have a particular locale installed
	# upstream bug #742708
	sed '/test_non_utf8_import (plugin/ d' \
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

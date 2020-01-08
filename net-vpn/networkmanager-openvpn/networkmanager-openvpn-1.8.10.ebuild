# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2 user

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=net-misc/networkmanager-1.7.0:=
	>=net-vpn/openvpn-2.1
	gtk? (
		>=app-crypt/libsecret-0.18
		>=gnome-extra/nm-applet-1.7.0
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

pkg_setup() {
	enewgroup nm-openvpn
	enewuser nm-openvpn -1 -1 -1 nm-openvpn
}

src_prepare() {
	# Test will fail if the machine doesn't have a particular locale installed
	# FAIL: (tls-import-data) unexpected 'ca' secret value, upstream bug #742708
	sed '/test_non_utf8_import (plugin, test_dir)/ d' \
		-i properties/tests/test-import-export.c || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	# --localstatedir=/var needed per bug #536248
	gnome2_src_configure \
		--localstatedir=/var \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome)
}

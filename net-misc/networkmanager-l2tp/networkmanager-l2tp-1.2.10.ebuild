# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

EGO_PN="github.com/nm-l2tp/network-manager-l2tp"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="gtk nls static-libs"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	>=net-dialup/ppp-2.4.7
	net-dialup/xl2tpd
	|| (
		net-vpn/libreswan
		net-vpn/strongswan
	)
	>=net-misc/networkmanager-1.8.0
	sys-apps/dbus
	app-crypt/libsecret
	gtk? ( gnome-base/libgnome-keyring x11-libs/gtk+:3 )"

DEPEND="${RDEPEND}
	dev-perl/XML-Parser
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35.0
	>=dev-lang/perl-5.8.1
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/network-manager-l2tp-1.2.10"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with gtk gnome) \
		--disable-more-warnings \
		--with-dist-version=Gentoo \
		--with-pic
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="NetworkManager-l2tp"
MY_P="${MY_PN}-${PV}"

inherit autotools gnome.org

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI="https://github.com/nm-l2tp/${MY_PN}/releases/download/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk static-libs"

RDEPEND="
	>=net-misc/networkmanager-1.2[ppp]
	dev-libs/dbus-glib
	net-dialup/ppp:=[eap-tls]
	net-dialup/xl2tpd
	>=dev-libs/glib-2.32
	|| (
		net-vpn/strongswan
		net-vpn/libreswan
	)
	gtk? (
		x11-libs/gtk+:3
		app-crypt/libsecret
		gnome-extra/nm-applet
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} # reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision

	local myeconfargs=(
		--localstatedir=/var
		--with-pppd-plugin-dir=/usr/$(get_libdir)/pppd/${PPPD_VER}
		$(use_with gtk gnome)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

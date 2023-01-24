# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="NetworkManager-l2tp"
MY_P="${MY_PN}-${PV}"

inherit gnome.org

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/nm-l2tp/NetworkManager-l2tp"
SRC_URI="https://github.com/nm-l2tp/${MY_PN}/releases/download/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/openssl:=
	net-dialup/ppp:=[eap-tls]
	net-dialup/xl2tpd
	>=net-misc/networkmanager-1.20[ppp]
	|| (
		net-vpn/strongswan
		net-vpn/libreswan
	)
	gtk? (
		app-crypt/libsecret
		gnome-extra/nm-applet
		media-libs/harfbuzz:=
		net-libs/libnma
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
	)"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
RDEPEND="${COMMON_DEPEND}
	dev-libs/dbus-glib"
BDEPEND="dev-util/gdbus-codegen
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PPPD_VER=$(best_version net-dialup/ppp)
	PPPD_VER=${PPPD_VER#*/*-} # reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision

	local myeconfargs=(
		--localstatedir=/var
		--with-pppd-plugin-dir=/usr/$(get_libdir)/pppd/${PPPD_VER}
		$(use_with gtk gnome)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

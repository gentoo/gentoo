# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit autotools systemd

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="https://01.org/connman"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="bluetooth debug doc examples +ethernet l2tp ofono openvpn openconnect pptp policykit tools vpnc +wifi wispr"

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	>=net-firewall/iptables-1.4.8
	bluetooth? ( net-wireless/bluez )
	l2tp? ( net-dialup/xl2tpd )
	ofono? ( net-misc/ofono )
	openconnect? ( net-misc/openconnect )
	openvpn? ( net-misc/openvpn )
	policykit? ( sys-auth/polkit )
	pptp? ( net-dialup/pptpclient )
	vpnc? ( net-misc/vpnc )
	wifi? ( >=net-wireless/wpa_supplicant-2.0[dbus] )
	wispr? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.31-xtables.patch"
	"${FILESDIR}/${PN}-1.33-polkit-configure-check-fix.patch"
	"${FILESDIR}/${PN}-1.33-resolv-conf-overwrite.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-systemdunitdir=$(systemd_get_systemunitdir) \
		--with-tmpfilesdir=${EPRIFEX}/usr/lib/tmpfiles.d \
		--enable-client \
		--enable-datafiles \
		--enable-loopback=builtin \
		$(use_enable examples test) \
		$(use_enable ethernet ethernet builtin) \
		$(use_enable wifi wifi builtin) \
		$(use_enable bluetooth bluetooth builtin) \
		$(use_enable l2tp l2tp builtin) \
		$(use_enable ofono ofono builtin) \
		$(use_enable openconnect openconnect builtin) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable pptp pptp builtin) \
		$(use_enable vpnc vpnc builtin) \
		$(use_enable wispr wispr builtin) \
		$(use_enable debug) \
		$(use_enable tools) \
		--disable-iospm \
		--disable-hh2serial-gps
}

src_install() {
	default
	dobin client/connmanctl

	if use doc; then
		dodoc doc/*.txt
	fi
	keepdir /usr/lib/${PN}/scripts
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}"/${PN}.initd2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

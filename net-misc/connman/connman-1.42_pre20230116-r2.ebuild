# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
inherit autotools systemd tmpfiles

COMMIT=9971144ae862e83f1f5d8cb84c0b62f2542dcdec

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/network/connman/connman.git"
else
	SRC_URI="https://git.kernel.org/pub/scm/network/connman/connman.git/snapshot/connman-${COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="https://git.kernel.org/pub/scm/network/connman/connman.git/"

LICENSE="GPL-2"
SLOT="0"

IUSE="bluetooth debug doc +ethernet examples iptables iwd l2tp networkmanager
+nftables ofono openconnect openvpn policykit pptp tools vpnc +wifi wireguard
wispr"

REQUIRED_USE="^^ ( iptables nftables )"
BDEPEND="virtual/pkgconfig"
COMMON_DEPEND=">=dev-libs/glib-2.16
	net-libs/gnutls
	>=sys-apps/dbus-1.2.24
	sys-libs/readline:0=
	nftables? (
		>=net-libs/libnftnl-1.0.4:0=
		>=net-libs/libmnl-1.0.0:0=
	)
	openconnect? ( net-vpn/openconnect )
	openvpn? ( net-vpn/openvpn )
	pptp? ( net-dialup/pptpclient )
	vpnc? ( net-vpn/vpnc )
	wireguard? ( >=net-libs/libmnl-1.0.0:0= )"
RDEPEND="${COMMON_DEPEND}
	bluetooth? ( net-wireless/bluez )
	iptables? ( >=net-firewall/iptables-1.4.8 )
	l2tp? ( net-dialup/xl2tpd )
	ofono? ( net-misc/ofono )
	policykit? ( sys-auth/polkit )
	wifi? (
		!iwd? ( >=net-wireless/wpa_supplicant-0.7.3-r3[dbus] )
		iwd? ( net-wireless/iwd )
	)"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-2.6.39"

PATCHES=( "${FILESDIR}/libresolv-musl-fix.patch" )
S=${WORKDIR}/${PN}-${COMMIT}

src_prepare() {
	default
	eautoreconf

	cp "${FILESDIR}"/connman.initd2 "${T}"
	if use iwd; then
		sed -i \
			-e "s/need dbus/need dbus iwd/" \
			-e '/start-stop-daemon --start/ s/ -- / -- --wifi=iwd_agent /' \
			"${T}"/connman.initd2 || die
		sed -i \
			-e "/^ExecStart/ s/$/ --wifi=iwd_agent/" \
			src/connman.service.in || die
	fi
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var \
		--runstatedir=/run \
		--with-systemdunitdir=$(systemd_get_systemunitdir) \
		--with-tmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d \
		--enable-client \
		--enable-datafiles \
		--enable-loopback=builtin \
		$(use_enable bluetooth bluetooth builtin) \
		$(use_enable debug) \
		$(use_enable ethernet ethernet builtin) \
		$(use_enable examples test) \
		$(use_enable l2tp l2tp builtin) \
		$(use_enable networkmanager nmcompat) \
		$(use_enable ofono ofono builtin) \
		$(use_enable openconnect openconnect builtin) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable pptp pptp builtin) \
		$(use_enable tools) \
		$(use_enable vpnc vpnc builtin) \
		$(use_enable wireguard) \
		$(use_enable wispr wispr builtin) \
		--with-firewall=$(usex iptables "iptables" "nftables" ) \
		--disable-iospm \
		--disable-hh2serial-gps
		)
	# wifi USE logic to match networkmanager ebuild behavior
	if use wifi; then
		if use iwd; then
			myeconfargs+=( --enable-iwd --disable-wifi )
		else
			myeconfargs+=( --disable-iwd --enable-wifi=builtin )
		fi
	else
		myeconfargs+=( --disable-iwd --disable-wifi )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dobin client/connmanctl

	if use doc; then
		dodoc doc/*.txt
	fi
	keepdir /usr/lib/${PN}/scripts
	keepdir /var/lib/${PN}
	newinitd "${T}"/${PN}.initd2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	tmpfiles_process connman_resolvconf.conf
}

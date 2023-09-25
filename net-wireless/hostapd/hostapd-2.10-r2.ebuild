# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd savedconfig toolchain-funcs

EXTRAS_VER="2.7-r2"
EXTRAS_NAME="${CATEGORY}_${PN}_${EXTRAS_VER}_extras"
DESCRIPTION="IEEE 802.11 wireless LAN Host AP daemon"
HOMEPAGE="https://w1.fi/ https://w1.fi/cgit/hostap/"
SRC_URI="https://dev.gentoo.org/~andrey_utkin/distfiles/${EXTRAS_NAME}.tar.xz"
S="${S}/${PN}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://w1.fi/hostap.git"
else
	if [[ ${PV} =~ ^.*_p[0-9]{8}$ ]]; then
		SRC_URI+=" https://dev.gentoo.org/~andrey_utkin/distfiles/${P}.tar.xz"
	else
		SRC_URI+=" https://w1.fi/releases/${P}.tar.gz"
	fi

	# Never stabilize snapshot ebuilds please
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="internal-tls ipv6 netlink selinux sqlite +suiteb +wps"

DEPEND="
	internal-tls? ( dev-libs/libtommath )
	!internal-tls? ( dev-libs/openssl:0=[-bindist(-)] )
	kernel_linux? (
		net-wireless/wireless-regdb
		>=dev-libs/libnl-3.2:3
	)
	netlink? ( net-libs/libnfnetlink )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-hostapd )
"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	if use internal-tls; then
		ewarn "internal-tls implementation is experimental and provides fewer features"
	fi
}

src_unpack() {
	# Override default one because we need the SRC_URI ones even in case of 9999 ebuilds
	default

	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# Allow users to apply patches to src/drivers for example,
	# i.e. anything outside ${S}/${PN}
	pushd ../ >/dev/null || die
	default
	popd >/dev/null || die

	sed -i -e "s:/etc/hostapd:/etc/hostapd/hostapd:g" \
		"${S}/hostapd.conf" || die
}

src_configure() {
	local CONFIG="${S}"/.config

	restore_config "${CONFIG}"
	if [[ -f "${CONFIG}" ]]; then
		default
		return 0
	fi

	# toolchain setup
	echo "CC = $(tc-getCC)" > ${CONFIG} || die

	# EAP authentication methods
	echo "CONFIG_EAP=y" >> ${CONFIG} || die
	echo "CONFIG_ERP=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_MD5=y" >> ${CONFIG} || die

	if use suiteb; then
		echo "CONFIG_SUITEB=y" >> ${CONFIG} || die
		echo "CONFIG_SUITEB192=y" >> ${CONFIG} || die
	fi

	if use internal-tls ; then
		echo "CONFIG_TLS=internal" >> ${CONFIG} || die
	else
		# SSL authentication methods
		echo "CONFIG_DPP=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_FAST=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_MSCHAPV2=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_PEAP=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_PWD=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_TLS=y" >> ${CONFIG} || die
		echo "CONFIG_EAP_TTLS=y" >> ${CONFIG} || die
		echo "CONFIG_OWE=y" >> ${CONFIG} || die
		echo "CONFIG_SAE=y" >> ${CONFIG} || die
		echo "CONFIG_TLSV11=y" >> ${CONFIG} || die
		echo "CONFIG_TLSV12=y" >> ${CONFIG} || die
	fi

	if use wps; then
		# Enable Wi-Fi Protected Setup
		echo "CONFIG_WPS=y" >> ${CONFIG} || die
		echo "CONFIG_WPS2=y" >> ${CONFIG} || die
		echo "CONFIG_WPS_UPNP=y" >> ${CONFIG} || die
		echo "CONFIG_WPS_NFC=y" >> ${CONFIG} || die
		einfo "Enabling Wi-Fi Protected Setup support"
	fi

	echo "CONFIG_EAP_IKEV2=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_TNC=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_GTC=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_SIM=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_AKA=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_AKA_PRIME=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_EKE=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_PAX=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_PSK=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_SAKE=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_GPSK=y" >> ${CONFIG} || die
	echo "CONFIG_EAP_GPSK_SHA256=y" >> ${CONFIG} || die

	einfo "Enabling drivers: "

	# drivers
	echo "CONFIG_DRIVER_HOSTAP=y" >> ${CONFIG} || die
	einfo "  HostAP driver enabled"
	echo "CONFIG_DRIVER_WIRED=y" >> ${CONFIG} || die
	einfo "  Wired driver enabled"
	echo "CONFIG_DRIVER_NONE=y" >> ${CONFIG} || die
	einfo "  None driver enabled"

	einfo "  nl80211 driver enabled"
	echo "CONFIG_DRIVER_NL80211=y" >> ${CONFIG} || die

	# epoll
	echo "CONFIG_ELOOP_EPOLL=y" >> ${CONFIG} || die

	# misc
	echo "CONFIG_DEBUG_FILE=y" >> ${CONFIG} || die
	echo "CONFIG_PKCS12=y" >> ${CONFIG} || die
	echo "CONFIG_RADIUS_SERVER=y" >> ${CONFIG} || die
	echo "CONFIG_IAPP=y" >> ${CONFIG} || die
	echo "CONFIG_IEEE80211R=y" >> ${CONFIG} || die
	echo "CONFIG_IEEE80211W=y" >> ${CONFIG} || die
	echo "CONFIG_IEEE80211N=y" >> ${CONFIG} || die
	echo "CONFIG_IEEE80211AC=y" >> ${CONFIG} || die
	echo "CONFIG_IEEE80211AX=y" >> ${CONFIG} || die
	echo "CONFIG_OCV=y" >> ${CONFIG} || die
	echo "CONFIG_PEERKEY=y" >> ${CONFIG} || die
	echo "CONFIG_RSN_PREAUTH=y" >> ${CONFIG} || die
	echo "CONFIG_INTERWORKING=y" >> ${CONFIG} || die
	echo "CONFIG_FULL_DYNAMIC_VLAN=y" >> ${CONFIG} || die
	echo "CONFIG_HS20=y" >> ${CONFIG} || die
	echo "CONFIG_WNM=y" >> ${CONFIG} || die
	echo "CONFIG_FST=y" >> ${CONFIG} || die
	echo "CONFIG_FST_TEST=y" >> ${CONFIG} || die
	echo "CONFIG_ACS=y" >> ${CONFIG} || die

	if use netlink; then
		# Netlink support
		echo "CONFIG_VLAN_NETLINK=y" >> ${CONFIG} || die
	fi

	if use ipv6; then
		# IPv6 support
		echo "CONFIG_IPV6=y" >> ${CONFIG} || die
	fi

	if use sqlite; then
		# Sqlite support
		echo "CONFIG_SQLITE=y" >> ${CONFIG} || die
	fi

	if use kernel_linux; then
		echo "CONFIG_LIBNL32=y" >> ${CONFIG} || die
		append-cflags $($(tc-getPKG_CONFIG) --cflags libnl-3.0)
	fi

	# TODO: Add support for BSD drivers

	default
}

src_compile() {
	emake V=1

	if ! use internal-tls; then
		emake V=1 nt_password_hash
		emake V=1 hlr_auc_gw
	fi
}

src_install() {
	insinto /etc/${PN}
	doins ${PN}.{conf,accept,deny,eap_user,radius_clients,sim_db,wpa_psk}

	fperms -R 600 /etc/${PN}

	dosbin ${PN}
	dobin ${PN}_cli

	if ! use internal-tls; then
		dobin nt_password_hash hlr_auc_gw
	fi

	newinitd "${WORKDIR}/${EXTRAS_NAME}"/${PN}-init.d ${PN}
	newconfd "${WORKDIR}/${EXTRAS_NAME}"/${PN}-conf.d ${PN}
	systemd_dounit "${WORKDIR}/${EXTRAS_NAME}"/${PN}.service

	doman ${PN}{.8,_cli.1}

	dodoc ChangeLog README
	use wps && dodoc README-WPS

	docinto examples
	dodoc wired.conf

	insinto /etc/log.d/conf/services/
	doins logwatch/${PN}.conf

	exeinto /etc/log.d/scripts/services/
	doexe logwatch/${PN}

	save_config .config
}

pkg_postinst() {
	einfo
	einfo "If you are running OpenRC you need to follow this instructions:"
	einfo "In order to use ${PN} you need to set up your wireless card"
	einfo "for master mode in /etc/conf.d/net and then start"
	einfo "/etc/init.d/${PN}."
	einfo
	einfo "Example configuration:"
	einfo
	einfo "config_wlan0=( \"192.168.1.1/24\" )"
	einfo "channel_wlan0=\"6\""
	einfo "essid_wlan0=\"test\""
	einfo "mode_wlan0=\"master\""
	einfo

	#if [[ -e "${KV_DIR}"/net/mac80211 ]]; then
	#	einfo "This package now compiles against the headers installed by"
	#	einfo "the kernel source for the mac80211 driver. You should "
	#	einfo "re-emerge ${PN} after upgrading your kernel source."
	#fi

	if use wps; then
		einfo "You have enabled Wi-Fi Protected Setup support, please"
		einfo "read the README-WPS file in /usr/share/doc/${PF}"
		einfo "for info on how to use WPS"
	fi
}

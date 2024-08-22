# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop linux-info qmake-utils readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="IEEE 802.1X/WPA supplicant for secure wireless transfers"
HOMEPAGE="https://w1.fi/wpa_supplicant/"
LICENSE="|| ( GPL-2 BSD )"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://w1.fi/hostap.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://w1.fi/releases/${P}.tar.gz"
fi

SLOT="0"
IUSE="ap broadcom-sta dbus eap-sim eapol-test fasteap +fils +hs2-0 macsec +mbo +mesh p2p privsep ps3 qt5 readline selinux smartcard tdls tkip uncommon-eap-types wep wimax wps"

# CONFIG_PRIVSEP=y does not have sufficient support for the new driver
# interface functions used for MACsec, so this combination cannot be used
# at least for now. bug #684442
REQUIRED_USE="
	macsec? ( !privsep )
	privsep? ( !macsec )
	broadcom-sta? ( !fils !mesh !mbo )
"

DEPEND="
	>=dev-libs/openssl-1.0.2k:=
	dbus? ( sys-apps/dbus )
	kernel_linux? (
		>=dev-libs/libnl-3.2:3
		eap-sim? ( sys-apps/pcsc-lite )
	)
	!kernel_linux? ( net-libs/libpcap )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	readline? (
		sys-libs/ncurses:0=
		sys-libs/readline:0=
	)
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-networkmanager )
	kernel_linux? (
		net-wireless/wireless-regdb
	)
"
BDEPEND="virtual/pkgconfig"

DOC_CONTENTS="
	If this is a clean installation of wpa_supplicant, you
	have to create a configuration file named
	/etc/wpa_supplicant/wpa_supplicant.conf
	An example configuration file is available for reference in
	/usr/share/doc/${PF}/
"

S="${WORKDIR}/${P}/${PN}"

Kconfig_style_config() {
		#param 1 is CONFIG_* item
		#param 2 is what to set it = to, defaulting in y
		CONFIG_PARAM="${CONFIG_HEADER:-CONFIG_}$1"
		setting="${2:-y}"

		if [ ! $setting = n ]; then
			#first remove any leading "# " if $2 is not n
			sed -i "/^# *$CONFIG_PARAM=/s/^# *//" .config || echo "Kconfig_style_config error uncommenting $CONFIG_PARAM"
			#set item = $setting (defaulting to y)
			if ! sed -i "/^$CONFIG_PARAM\>/s/=.*/=$setting/" .config; then
				echo "Kconfig_style_config error setting $CONFIG_PARAM=$setting"
			fi
			if [ -z "$( grep ^$CONFIG_PARAM= .config )" ] ; then
				echo "$CONFIG_PARAM=$setting" >>.config
			fi
		else
			#ensure item commented out
			if ! sed -i "/^$CONFIG_PARAM\>/s/$CONFIG_PARAM/# $CONFIG_PARAM/" .config; then
				echo "Kconfig_style_config error commenting $CONFIG_PARAM"
			fi
		fi
}

src_prepare() {
	default

	# net/bpf.h needed for net-libs/libpcap on Gentoo/FreeBSD
	sed -i \
		-e "s:\(#include <pcap\.h>\):#include <net/bpf.h>\n\1:" \
		../src/l2_packet/l2_packet_freebsd.c || die

	# Change configuration to match Gentoo locations (bug #143750)
	sed -i \
		-e "s:/usr/lib/opensc:/usr/$(get_libdir):" \
		-e "s:/usr/lib/pkcs11:/usr/$(get_libdir):" \
		wpa_supplicant.conf || die

	# systemd entries to D-Bus service files (bug #372877)
	echo 'SystemdService=wpa_supplicant.service' \
		| tee -a dbus/*.service >/dev/null || die

	cd "${WORKDIR}/${P}" || die

	if use wimax; then
		# generate-libeap-peer.patch comes before
		# fix-undefined-reference-to-random_get_bytes.patch
		eapply "${FILESDIR}/${P}-generate-libeap-peer.patch"

		# multilib-strict fix (bug #373685)
		sed -e "s/\/usr\/lib/\/usr\/$(get_libdir)/" -i src/eap_peer/Makefile || die
	fi

	# bug (320097)
	eapply "${FILESDIR}/${PN}-2.6-do-not-call-dbus-functions-with-NULL-path.patch"

	# bug (912315)
	eapply "${FILESDIR}/${PN}-2.10-allow-legacy-renegotiation.patch"

	# bug (640492)
	sed -i 's#-Werror ##' wpa_supplicant/Makefile || die
}

src_configure() {
	# Toolchain setup
	tc-export CC PKG_CONFIG

	cp defconfig .config || die

	# Basic setup
	Kconfig_style_config CTRL_IFACE
	Kconfig_style_config MATCH_IFACE
	Kconfig_style_config BACKEND file
	Kconfig_style_config IBSS_RSN
	Kconfig_style_config IEEE80211W
	Kconfig_style_config IEEE80211R
	Kconfig_style_config HT_OVERRIDES
	Kconfig_style_config VHT_OVERRIDES
	Kconfig_style_config OCV
	Kconfig_style_config TLSV11
	Kconfig_style_config TLSV12
	Kconfig_style_config GETRANDOM

	# Basic authentication methods
	# NOTE: we don't set GPSK or SAKE as they conflict
	# with the below options
	Kconfig_style_config EAP_GTC
	Kconfig_style_config EAP_MD5
	Kconfig_style_config EAP_OTP
	Kconfig_style_config EAP_PAX
	Kconfig_style_config EAP_PSK
	Kconfig_style_config EAP_TLV
	Kconfig_style_config EAP_EXE
	Kconfig_style_config IEEE8021X_EAPOL
	Kconfig_style_config PKCS12
	Kconfig_style_config PEERKEY
	Kconfig_style_config EAP_LEAP
	Kconfig_style_config EAP_MSCHAPV2
	Kconfig_style_config EAP_PEAP
	Kconfig_style_config EAP_TEAP
	Kconfig_style_config EAP_TLS
	Kconfig_style_config EAP_TTLS

	# Enabling background scanning.
	Kconfig_style_config BGSCAN_SIMPLE
	Kconfig_style_config BGSCAN_LEARN

	if use dbus ; then
		Kconfig_style_config CTRL_IFACE_DBUS
		Kconfig_style_config CTRL_IFACE_DBUS_NEW
		Kconfig_style_config CTRL_IFACE_DBUS_INTRO
	else
		Kconfig_style_config CTRL_IFACE_DBUS n
		Kconfig_style_config CTRL_IFACE_DBUS_NEW n
		Kconfig_style_config CTRL_IFACE_DBUS_INTRO n
	fi

	if use eapol-test ; then
		Kconfig_style_config EAPOL_TEST
	fi

	# Enable support for writing debug info to a log file and syslog.
	Kconfig_style_config DEBUG_FILE
	Kconfig_style_config DEBUG_SYSLOG

	if use hs2-0 ; then
		Kconfig_style_config INTERWORKING
		Kconfig_style_config HS20
	fi

	if use mbo ; then
		Kconfig_style_config MBO
	else
		Kconfig_style_config MBO n
	fi

	if use uncommon-eap-types; then
		Kconfig_style_config EAP_GPSK
		Kconfig_style_config EAP_SAKE
		Kconfig_style_config EAP_GPSK_SHA256
		Kconfig_style_config EAP_IKEV2
		Kconfig_style_config EAP_EKE
	fi

	if use eap-sim ; then
		# Smart card authentication
		Kconfig_style_config EAP_SIM
		Kconfig_style_config EAP_AKA
		Kconfig_style_config EAP_AKA_PRIME
		Kconfig_style_config PCSC
	fi

	if use fasteap ; then
		Kconfig_style_config EAP_FAST
	fi

	if use readline ; then
		# readline/history support for wpa_cli
		Kconfig_style_config READLINE
	else
		#internal line edit mode for wpa_cli
		Kconfig_style_config WPA_CLI_EDIT
	fi

	Kconfig_style_config TLS openssl
	Kconfig_style_config FST

	Kconfig_style_config EAP_PWD
	if use fils; then
		Kconfig_style_config FILS
		Kconfig_style_config FILS_SK_PFS
	fi
	if use mesh; then
		Kconfig_style_config MESH
	else
		Kconfig_style_config MESH n
	fi
	# WPA3
	Kconfig_style_config OWE
	Kconfig_style_config SAE
	Kconfig_style_config DPP
	Kconfig_style_config DPP2
	Kconfig_style_config SUITEB192
	Kconfig_style_config SUITEB

	if use wep ; then
		Kconfig_style_config WEP
	else
		Kconfig_style_config WEP n
	fi

	# Watch out, reversed logic
	if use tkip ; then
		Kconfig_style_config NO_TKIP n
	else
		Kconfig_style_config NO_TKIP
	fi

	if use smartcard ; then
		Kconfig_style_config SMARTCARD
	else
		Kconfig_style_config SMARTCARD n
	fi

	if use tdls ; then
		Kconfig_style_config TDLS
	fi

	if use kernel_linux ; then
		# Linux specific drivers
		Kconfig_style_config DRIVER_ATMEL
		Kconfig_style_config DRIVER_HOSTAP
		Kconfig_style_config DRIVER_IPW
		Kconfig_style_config DRIVER_NL80211
		Kconfig_style_config DRIVER_RALINK
		Kconfig_style_config DRIVER_WEXT
		Kconfig_style_config DRIVER_WIRED

		if use macsec ; then
			#requires something, no idea what
			#Kconfig_style_config DRIVER_MACSEC_QCA
			Kconfig_style_config DRIVER_MACSEC_LINUX
			Kconfig_style_config MACSEC
		else
			# bug #831369 and bug #684442
			Kconfig_style_config DRIVER_MACSEC_LINUX n
			Kconfig_style_config MACSEC n
		fi

		if use ps3 ; then
			Kconfig_style_config DRIVER_PS3
		fi
	fi

	# Wi-Fi Protected Setup (WPS)
	if use wps ; then
		Kconfig_style_config WPS
		Kconfig_style_config WPS2
		# USB Flash Drive
		Kconfig_style_config WPS_UFD
		# External Registrar
		Kconfig_style_config WPS_ER
		# Universal Plug'n'Play
		Kconfig_style_config WPS_UPNP
		# Near Field Communication
		Kconfig_style_config WPS_NFC
	else
		Kconfig_style_config WPS n
		Kconfig_style_config WPS2 n
		Kconfig_style_config WPS_UFD n
		Kconfig_style_config WPS_ER n
		Kconfig_style_config WPS_UPNP n
		Kconfig_style_config WPS_NFC n
	fi

	# Wi-Fi Direct (WiDi)
	if use p2p ; then
		Kconfig_style_config P2P
		Kconfig_style_config WIFI_DISPLAY
	else
		Kconfig_style_config P2P n
		Kconfig_style_config WIFI_DISPLAY n
	fi

	# Access Point Mode
	if use ap ; then
		Kconfig_style_config AP
	else
		Kconfig_style_config AP n
	fi

	# Enable essentials for AP/P2P
	if use ap || use p2p ; then
		# Enabling HT support (802.11n)
		Kconfig_style_config IEEE80211N

		# Enabling VHT support (802.11ac)
		Kconfig_style_config IEEE80211AC
	fi

	# Enable mitigation against certain attacks against TKIP
	Kconfig_style_config DELAYED_MIC_ERROR_REPORT

	if use privsep ; then
		Kconfig_style_config PRIVSEP
	fi

	if use kernel_linux ; then
		Kconfig_style_config LIBNL32
	fi

	if use qt5 ; then
		pushd "${S}"/wpa_gui-qt4 > /dev/null || die
		eqmake5 wpa_gui.pro
		popd > /dev/null || die
	fi
}

src_compile() {
	einfo "Building wpa_supplicant"
	emake V=1 BINDIR=/usr/sbin

	if use wimax; then
		emake -C ../src/eap_peer clean
		emake -C ../src/eap_peer
	fi

	if use qt5; then
		einfo "Building wpa_gui"
		emake -C "${S}"/wpa_gui-qt4
	fi

	if use eapol-test ; then
		emake eapol_test
	fi
}

src_install() {
	dosbin wpa_supplicant
	use privsep && dosbin wpa_priv
	dobin wpa_cli wpa_passphrase

	newinitd "${FILESDIR}/${PN}-init.d" wpa_supplicant
	newconfd "${FILESDIR}/${PN}-conf.d" wpa_supplicant

	exeinto /etc/wpa_supplicant/
	newexe "${FILESDIR}/wpa_cli-r1.sh" wpa_cli.sh

	readme.gentoo_create_doc
	dodoc ChangeLog {eap_testing,todo}.txt README{,-WPS} \
		wpa_supplicant.conf

	newdoc .config build-config

	if [ "${PV}" != "9999" ]; then
		doman doc/docbook/*.{5,8}
	fi

	if use qt5 ; then
		into /usr
		dobin wpa_gui-qt4/wpa_gui
		doicon wpa_gui-qt4/icons/wpa_gui.svg
		domenu wpa_gui-qt4/wpa_gui.desktop
	else
		rm "${ED}"/usr/share/man/man8/wpa_gui.8
	fi

	use wimax && emake DESTDIR="${D}" -C ../src/eap_peer install

	if use dbus ; then
		pushd "${S}"/dbus > /dev/null || die
		insinto /etc/dbus-1/system.d
		newins dbus-wpa_supplicant.conf wpa_supplicant.conf
		insinto /usr/share/dbus-1/system-services
		doins fi.w1.wpa_supplicant1.service
		popd > /dev/null || die

		# This unit relies on dbus support, bug 538600.
		systemd_dounit systemd/wpa_supplicant.service
	fi

	if use eapol-test ; then
		dobin eapol_test
	fi

	systemd_dounit "systemd/wpa_supplicant@.service"
	systemd_dounit "systemd/wpa_supplicant-nl80211@.service"
	systemd_dounit "systemd/wpa_supplicant-wired@.service"
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -e "${EROOT}"/etc/wpa_supplicant.conf ]] ; then
		echo
		ewarn "WARNING: your old configuration file ${EROOT}/etc/wpa_supplicant.conf"
		ewarn "needs to be moved to ${EROOT}/etc/wpa_supplicant/wpa_supplicant.conf"
	fi
	if ! use wep; then
		einfo "WARNING: You are building with WEP support disabled, which is recommended since"
		einfo "this protocol is deprecated and insecure.  If you still need to connect to"
		einfo "WEP-enabled networks, you may turn this flag back on.  With this flag off,"
		einfo "WEP-enabled networks will not even show up as available."
		einfo "If your network is missing you may wish to USE=wep"
	fi
	if ! use tkip; then
		ewarn "WARNING: You are building with TKIP support disabled, which is recommended since"
		ewarn "this protocol is deprecated and insecure.  If you still need to connect to"
		ewarn "TKIP-enabled networks, you may turn this flag back on.  With this flag off,"
		ewarn "TKIP-enabled networks, including mixed mode TKIP/AES-CCMP will not even show up"
		ewarn "as available.  If your network is missing you may wish to USE=tkip"
	fi

	# Mea culpa, feel free to remove that after some time --mgorny.
	local fn
	for fn in wpa_supplicant{,@wlan0}.service; do
		if [[ -e "${EROOT}"/etc/systemd/system/network.target.wants/${fn} ]]
		then
			ebegin "Moving ${fn} to multi-user.target"
			mv "${EROOT}"/etc/systemd/system/network.target.wants/${fn} \
				"${EROOT}"/etc/systemd/system/multi-user.target.wants/ || die
			eend ${?} \
				"Please try to re-enable ${fn}"
		fi
	done

	systemd_reenable wpa_supplicant.service
}

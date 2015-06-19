# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wpa_supplicant/wpa_supplicant-2.4-r3.ebuild,v 1.6 2015/05/28 08:10:04 gurligebis Exp $

EAPI=5

inherit eutils toolchain-funcs qt4-r2 systemd multilib

DESCRIPTION="IEEE 802.1X/WPA supplicant for secure wireless transfers"
HOMEPAGE="http://hostap.epitest.fi/wpa_supplicant/"
SRC_URI="http://hostap.epitest.fi/releases/${P}.tar.gz"
LICENSE="|| ( GPL-2 BSD )"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="ap dbus gnutls eap-sim fasteap +hs2-0 p2p ps3 qt4 readline selinux smartcard ssl tdls uncommon-eap-types wimax wps kernel_linux kernel_FreeBSD"
REQUIRED_USE="fasteap? ( !gnutls !ssl ) smartcard? ( ssl )"

CDEPEND="dbus? ( sys-apps/dbus )
	kernel_linux? (
		eap-sim? ( sys-apps/pcsc-lite )
		dev-libs/libnl:3
		net-wireless/crda
	)
	!kernel_linux? ( net-libs/libpcap )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	readline? (
		sys-libs/ncurses
		sys-libs/readline:0
	)
	ssl? ( dev-libs/openssl:0 )
	!ssl? ( gnutls? ( net-libs/gnutls ) )
	!ssl? ( !gnutls? ( dev-libs/libtommath ) )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-networkmanager )
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
			sed -i "/^$CONFIG_PARAM/s/=.*/=$setting/" .config || echo "Kconfig_style_config error setting $CONFIG_PARAM=$setting"
		else
			#ensure item commented out
			sed -i "/^$CONFIG_PARAM/s/$CONFIG_PARAM/# $CONFIG_PARAM/" .config || echo "Kconfig_style_config error commenting $CONFIG_PARAM"
		fi
}

pkg_setup() {
	if use gnutls && use ssl ; then
		elog "You have both 'gnutls' and 'ssl' USE flags enabled: defaulting to USE=\"ssl\""
	fi
}

src_prepare() {
	# net/bpf.h needed for net-libs/libpcap on Gentoo/FreeBSD
	sed -i \
		-e "s:\(#include <pcap\.h>\):#include <net/bpf.h>\n\1:" \
		../src/l2_packet/l2_packet_freebsd.c || die

	# People seem to take the example configuration file too literally (bug #102361)
	sed -i \
		-e "s:^\(opensc_engine_path\):#\1:" \
		-e "s:^\(pkcs11_engine_path\):#\1:" \
		-e "s:^\(pkcs11_module_path\):#\1:" \
		wpa_supplicant.conf || die

	# Change configuration to match Gentoo locations (bug #143750)
	sed -i \
		-e "s:/usr/lib/opensc:/usr/$(get_libdir):" \
		-e "s:/usr/lib/pkcs11:/usr/$(get_libdir):" \
		wpa_supplicant.conf || die

	if use dbus; then
		epatch "${FILESDIR}/${P}-dbus-path-fix.patch"
	fi

	# systemd entries to D-Bus service files (bug #372877)
	echo 'SystemdService=wpa_supplicant.service' \
		| tee -a dbus/*.service >/dev/null || die

	cd "${WORKDIR}/${P}"

	if use wimax; then
		# generate-libeap-peer.patch comes before
		# fix-undefined-reference-to-random_get_bytes.patch
		epatch "${FILESDIR}/${P}-generate-libeap-peer.patch"

		# multilib-strict fix (bug #373685)
		sed -e "s/\/usr\/lib/\/usr\/$(get_libdir)/" -i src/eap_peer/Makefile
	fi

	# bug (548742)
	epatch "${FILESDIR}/2015-1/0001-P2P-Validate-SSID-element-length-before-copying-it-C.patch"
	epatch "${FILESDIR}/2015-2/0001-WPS-Fix-HTTP-chunked-transfer-encoding-parser.patch"
	epatch "${FILESDIR}/2015-3/0001-AP-WMM-Fix-integer-underflow-in-WMM-Action-frame-par.patch"
	epatch "${FILESDIR}/2015-4/0001-EAP-pwd-peer-Fix-payload-length-validation-for-Commi.patch"
	epatch "${FILESDIR}/2015-4/0002-EAP-pwd-server-Fix-payload-length-validation-for-Com.patch"
	epatch "${FILESDIR}/2015-4/0003-EAP-pwd-peer-Fix-Total-Length-parsing-for-fragment-r.patch"
	epatch "${FILESDIR}/2015-4/0004-EAP-pwd-server-Fix-Total-Length-parsing-for-fragment.patch"
	epatch "${FILESDIR}/2015-4/0005-EAP-pwd-peer-Fix-asymmetric-fragmentation-behavior.patch"

	# bug (320097)
	epatch "${FILESDIR}/${P}-do-not-call-dbus-functions-with-NULL-path.patch"

	# TODO - NEED TESTING TO SEE IF STILL NEEDED, NOT COMPATIBLE WITH 1.0 OUT OF THE BOX,
	# SO WOULD BE NICE TO JUST DROP IT, IF IT IS NOT NEEDED.
	# bug (374089)
	#epatch "${FILESDIR}/${P}-dbus-WPAIE-fix.patch"
}

src_configure() {
	# Toolchain setup
	tc-export CC

	cp defconfig .config

	# Basic setup
	Kconfig_style_config CTRL_IFACE
	Kconfig_style_config BACKEND file
	Kconfig_style_config IBSS_RSN
	Kconfig_style_config IEEE80211W
	Kconfig_style_config IEEE80211R

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
	Kconfig_style_config EAP_TLS
	Kconfig_style_config EAP_TTLS

	# Enabling background scanning.
	Kconfig_style_config BGSCAN_SIMPLE
	Kconfig_style_config BGSCAN_LEARN

	if use dbus ; then
		Kconfig_style_config CTRL_IFACE_DBUS
		Kconfig_style_config CTRL_IFACE_DBUS_NEW
		Kconfig_style_config CTRL_IFACE_DBUS_INTRO
	fi

	# Enable support for writing debug info to a log file and syslog.
	Kconfig_style_config DEBUG_FILE
	Kconfig_style_config DEBUG_SYSLOG

	if use hs2-0 ; then
		Kconfig_style_config INTERWORKING
		Kconfig_style_config HS20
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

	# SSL authentication methods
	if use ssl ; then
		Kconfig_style_config TLS openssl
	elif use gnutls ; then
		Kconfig_style_config TLS gnutls
		Kconfig_style_config GNUTLS_EXTRA
	else
		Kconfig_style_config TLS internal
	fi

	if use smartcard ; then
		Kconfig_style_config SMARTCARD
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

		if use ps3 ; then
			Kconfig_style_config DRIVER_PS3
		fi

	elif use kernel_FreeBSD ; then
		# FreeBSD specific driver
		Kconfig_style_config DRIVER_BSD
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
	fi

	# Wi-Fi Direct (WiDi)
	if use p2p ; then
		Kconfig_style_config P2P
		Kconfig_style_config WIFI_DISPLAY
	fi

	# Access Point Mode
	if use ap ; then
		Kconfig_style_config AP
	fi

	# Enable mitigation against certain attacks against TKIP
	Kconfig_style_config DELAYED_MIC_ERROR_REPORT

	# If we are using libnl 2.0 and above, enable support for it
	# Bug 382159
	# Removed for now, since the 3.2 version is broken, and we don't
	# support it.
	if has_version ">=dev-libs/libnl-3.2"; then
		Kconfig_style_config LIBNL32
	fi

	if use qt4 ; then
		pushd "${S}"/wpa_gui-qt4 > /dev/null
		eqmake4 wpa_gui.pro
		popd > /dev/null
	fi
}

src_compile() {
	einfo "Building wpa_supplicant"
	emake V=1 BINDIR=/usr/sbin

	if use wimax; then
		emake -C ../src/eap_peer clean
		emake -C ../src/eap_peer
	fi

	if use qt4 ; then
		pushd "${S}"/wpa_gui-qt4 > /dev/null
		einfo "Building wpa_gui"
		emake
		popd > /dev/null
	fi
}

src_install() {
	dosbin wpa_supplicant
	dobin wpa_cli wpa_passphrase

	# baselayout-1 compat
	if has_version "<sys-apps/baselayout-2.0.0"; then
		dodir /sbin
		dosym /usr/sbin/wpa_supplicant /sbin/wpa_supplicant
		dodir /bin
		dosym /usr/bin/wpa_cli /bin/wpa_cli
	fi

	if has_version ">=sys-apps/openrc-0.5.0"; then
		newinitd "${FILESDIR}/${PN}-init.d" wpa_supplicant
		newconfd "${FILESDIR}/${PN}-conf.d" wpa_supplicant
	fi

	exeinto /etc/wpa_supplicant/
	newexe "${FILESDIR}/wpa_cli.sh" wpa_cli.sh

	dodoc ChangeLog {eap_testing,todo}.txt README{,-WPS} \
		wpa_supplicant.conf

	newdoc .config build-config

	doman doc/docbook/*.{5,8}

	if use qt4 ; then
		into /usr
		dobin wpa_gui-qt4/wpa_gui
		doicon wpa_gui-qt4/icons/wpa_gui.svg
		make_desktop_entry wpa_gui "WPA Supplicant Administration GUI" "wpa_gui" "Qt;Network;"
	fi

	use wimax && emake DESTDIR="${D}" -C ../src/eap_peer install

	if use dbus ; then
		pushd "${S}"/dbus > /dev/null
		insinto /etc/dbus-1/system.d
		newins dbus-wpa_supplicant.conf wpa_supplicant.conf
		insinto /usr/share/dbus-1/system-services
		doins fi.epitest.hostap.WPASupplicant.service fi.w1.wpa_supplicant1.service
		popd > /dev/null

		# This unit relies on dbus support, bug 538600.
		systemd_dounit systemd/wpa_supplicant.service
	fi

	systemd_dounit "systemd/wpa_supplicant@.service"
	systemd_dounit "systemd/wpa_supplicant-nl80211@.service"
	systemd_dounit "systemd/wpa_supplicant-wired@.service"
}

pkg_postinst() {
	elog "If this is a clean installation of wpa_supplicant, you"
	elog "have to create a configuration file named"
	elog "/etc/wpa_supplicant/wpa_supplicant.conf"
	elog
	elog "An example configuration file is available for reference in"
	elog "/usr/share/doc/${PF}/"

	if [[ -e ${ROOT}etc/wpa_supplicant.conf ]] ; then
		echo
		ewarn "WARNING: your old configuration file ${ROOT}etc/wpa_supplicant.conf"
		ewarn "needs to be moved to ${ROOT}etc/wpa_supplicant/wpa_supplicant.conf"
	fi

	# Mea culpa, feel free to remove that after some time --mgorny.
	local fn
	for fn in wpa_supplicant{,@wlan0}.service; do
		if [[ -e "${ROOT}"/etc/systemd/system/network.target.wants/${fn} ]]
		then
			ebegin "Moving ${fn} to multi-user.target"
			mv "${ROOT}"/etc/systemd/system/network.target.wants/${fn} \
				"${ROOT}"/etc/systemd/system/multi-user.target.wants/
			eend ${?} \
				"Please try to re-enable ${fn}"
		fi
	done
}

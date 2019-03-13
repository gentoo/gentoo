# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils systemd toolchain-funcs readme.gentoo-r1

DESCRIPTION="IEEE 802.1X/WPA supplicant for secure wireless transfers"
HOMEPAGE="https://w1.fi/wpa_supplicant/"
LICENSE="|| ( GPL-2 BSD )"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://w1.fi/hostap.git"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
	SRC_URI="https://w1.fi/releases/${P}.tar.gz"
fi

SLOT="0"
IUSE="ap bindist dbus eap-sim eapol_test fasteap gnutls +hs2-0 libressl p2p privsep ps3 qt5 readline selinux smartcard ssl suiteb tdls uncommon-eap-types wimax wps kernel_linux kernel_FreeBSD"
REQUIRED_USE="smartcard? ( ssl )"

CDEPEND="dbus? ( sys-apps/dbus )
	kernel_linux? (
		dev-libs/libnl:3
		net-wireless/crda
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
	ssl? (
		gnutls? (
			dev-libs/libgcrypt:0=
			net-libs/gnutls:=
		)
		!gnutls? (
			!libressl? ( >=dev-libs/openssl-1.0.2k:0=[bindist=] )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	!ssl? ( dev-libs/libtommath )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-networkmanager )
"

DOC_CONTENTS="
	If this is a clean installation of wpa_supplicant, you
	have to create a configuration file named
	${EROOT%/}/etc/wpa_supplicant/wpa_supplicant.conf
	An example configuration file is available for reference in
	${EROOT%/}/usr/share/doc/${PF}/
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
			if [ -z "$( grep ^$CONFIG_PARAM= .config )" ] ; then
				echo "$CONFIG_PARAM=$setting" >>.config
			fi
		else
			#ensure item commented out
			sed -i "/^$CONFIG_PARAM/s/$CONFIG_PARAM/# $CONFIG_PARAM/" .config || echo "Kconfig_style_config error commenting $CONFIG_PARAM"
		fi
}

pkg_setup() {
	if use ssl ; then
		if use gnutls && use libressl ; then
			elog "You have both 'gnutls' and 'libressl' USE flags enabled: defaulting to USE=\"gnutls\""
		fi
	else
		elog "You have 'ssl' USE flag disabled: defaulting to internal TLS implementation"
	fi
}

src_prepare() {
	default

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

	# fix undefined reference to remove_ie()
	eapply "${FILESDIR}/${P}-fix-undefined-remove-ie.patch"

	# bug (672632)
	eapply "${FILESDIR}/${P}-libressl.patch"

	# bug (640492)
	sed -i 's#-Werror ##' wpa_supplicant/Makefile || die
}

src_configure() {
	# Toolchain setup
	tc-export CC

	cp defconfig .config || die

	# Basic setup
	Kconfig_style_config CTRL_IFACE
	Kconfig_style_config MATCH_IFACE
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

	if use eapol_test ; then
		Kconfig_style_config EAPOL_TEST
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

	if use suiteb; then
		Kconfig_style_config SUITEB
	fi

	# SSL authentication methods
	if use ssl ; then
		if use gnutls ; then
			Kconfig_style_config TLS gnutls
			Kconfig_style_config GNUTLS_EXTRA
		else
			#this fails for gnutls
			Kconfig_style_config SUITEB192
			Kconfig_style_config TLS openssl
			if ! use bindist; then
			  #this fails for gnutls
			  Kconfig_style_config EAP_PWD
			  # SAE fails on gnutls and everything below here needs SAE
			  # Enabling mesh networks.
			  Kconfig_style_config MESH
			  #WPA3
			  Kconfig_style_config OWE
			  Kconfig_style_config SAE
			  #we also need to disable FILS, except that isn't enabled yet
			fi

		fi
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

	# If we are using libnl 2.0 and above, enable support for it
	# Bug 382159
	# Removed for now, since the 3.2 version is broken, and we don't
	# support it.
	if has_version ">=dev-libs/libnl-3.2"; then
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

	if use eapol_test ; then
		emake eapol_test
	fi
}

src_install() {
	dosbin wpa_supplicant
	use privsep && dosbin wpa_priv
	dobin wpa_cli wpa_passphrase

	# baselayout-1 compat
	if has_version "<sys-apps/baselayout-2.0.0"; then
		dodir /sbin
		dosym ../usr/sbin/wpa_supplicant /sbin/wpa_supplicant
		dodir /bin
		dosym ../usr/bin/wpa_cli /bin/wpa_cli
	fi

	if has_version ">=sys-apps/openrc-0.5.0"; then
		newinitd "${FILESDIR}/${PN}-init.d" wpa_supplicant
		newconfd "${FILESDIR}/${PN}-conf.d" wpa_supplicant
	fi

	exeinto /etc/wpa_supplicant/
	newexe "${FILESDIR}/wpa_cli.sh" wpa_cli.sh

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
		make_desktop_entry wpa_gui "WPA Supplicant Administration GUI" "wpa_gui" "Qt;Network;"
	else
		rm "${ED}"/usr/share/man/man8/wpa_gui.8
	fi

	use wimax && emake DESTDIR="${D}" -C ../src/eap_peer install

	if use dbus ; then
		pushd "${S}"/dbus > /dev/null || die
		insinto /etc/dbus-1/system.d
		newins dbus-wpa_supplicant.conf wpa_supplicant.conf
		insinto /usr/share/dbus-1/system-services
		doins fi.epitest.hostap.WPASupplicant.service fi.w1.wpa_supplicant1.service
		popd > /dev/null || die

		# This unit relies on dbus support, bug 538600.
		systemd_dounit systemd/wpa_supplicant.service
	fi

	if use eapol_test ; then
		dobin eapol_test
	fi

	systemd_dounit "systemd/wpa_supplicant@.service"
	systemd_dounit "systemd/wpa_supplicant-nl80211@.service"
	systemd_dounit "systemd/wpa_supplicant-wired@.service"
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -e "${EROOT%/}"/etc/wpa_supplicant.conf ]] ; then
		echo
		ewarn "WARNING: your old configuration file ${EROOT%/}/etc/wpa_supplicant.conf"
		ewarn "needs to be moved to ${EROOT%/}/etc/wpa_supplicant/wpa_supplicant.conf"
	fi

	if use bindist || use gnutls; then
		if ! use libressl; then
			ewarn "Using bindist or gnutls use flags presently breaks WPA3 (specifically SAE and OWE)."
			ewarn "This is incredibly undesirable"
		fi
	fi

	# Mea culpa, feel free to remove that after some time --mgorny.
	local fn
	for fn in wpa_supplicant{,@wlan0}.service; do
		if [[ -e "${EROOT%/}"/etc/systemd/system/network.target.wants/${fn} ]]
		then
			ebegin "Moving ${fn} to multi-user.target"
			mv "${EROOT%/}"/etc/systemd/system/network.target.wants/${fn} \
				"${EROOT%/}"/etc/systemd/system/multi-user.target.wants/ || die
			eend ${?} \
				"Please try to re-enable ${fn}"
		fi
	done

	systemd_reenable wpa_supplicant.service
}

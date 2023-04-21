# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="NetworkManager"
PYTHON_COMPAT=( python3_{9..11} )

inherit gnome.org linux-info meson-multilib python-any-r1 readme.gentoo-r1 systemd toolchain-funcs udev vala virtualx

DESCRIPTION="A set of co-operative tools that make networking simple and straightforward"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="audit bluetooth +concheck connection-sharing debug dhclient dhcpcd elogind gnutls +gtk-doc +introspection iptables iwd psl libedit lto +nss nftables +modemmanager ofono ovs policykit +ppp resolvconf selinux syslog systemd teamd test +tools vala +wext +wifi"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	bluetooth? ( modemmanager )
	connection-sharing? ( || ( iptables nftables ) )
	gtk-doc? ( introspection )
	iwd? ( wifi )
	vala? ( introspection )
	wext? ( wifi )
	^^ ( gnutls nss )
	?? ( elogind systemd )
	?? ( dhclient dhcpcd )
	?? ( syslog systemd )
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

COMMON_DEPEND="
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	elogind? ( >=sys-auth/elogind-219 )
	>=virtual/libudev-175:=[${MULTILIB_USEDEP}]
	sys-apps/dbus
	net-libs/libndp
	systemd? ( >=sys-apps/systemd-209:0= )
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10.3:= )
	selinux? (
		sec-policy/selinux-networkmanager
		sys-libs/libselinux
	)
	audit? ( sys-process/audit )
	teamd? (
		>=dev-libs/jansson-2.7:=
		>=net-misc/libteam-1.9
	)
	policykit? ( >=sys-auth/polkit-0.106 )
	nss? (
		dev-libs/nspr[${MULTILIB_USEDEP}]
		>=dev-libs/nss-3.11[${MULTILIB_USEDEP}]
	)
	gnutls? (
		>=net-libs/gnutls-2.12:=[${MULTILIB_USEDEP}]
	)
	ppp? ( >=net-dialup/ppp-2.4.5:=[ipv6] )
	modemmanager? (
		net-misc/mobile-broadband-provider-info
		>=net-misc/modemmanager-0.7.991:0=
	)
	bluetooth? ( >=net-wireless/bluez-5:= )
	ofono? ( net-misc/ofono )
	dhclient? ( >=net-misc/dhcp-4[client] )
	dhcpcd? ( >=net-misc/dhcpcd-9.3.3 )
	ovs? ( >=dev-libs/jansson-2.7:= )
	resolvconf? ( virtual/resolvconf )
	connection-sharing? (
		net-dns/dnsmasq[dbus,dhcp]
		iptables? ( net-firewall/iptables )
		nftables? ( net-firewall/nftables )
	)
	psl? ( net-libs/libpsl )
	concheck? ( net-misc/curl )
	tools? (
		>=dev-libs/newt-0.52.15
		libedit? ( dev-libs/libedit )
		!libedit? ( sys-libs/readline:= )
	)
"
RDEPEND="${COMMON_DEPEND}
	acct-group/plugdev
	|| (
		net-misc/iputils[arping(+)]
		net-analyzer/arping
	)
	wifi? (
		!iwd? ( >=net-wireless/wpa_supplicant-0.7.3-r3[dbus] )
		iwd? ( net-wireless/iwd )
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.18
	net-libs/libndp[${MULTILIB_USEDEP}]
	ppp? ( elibc_musl? ( net-libs/ppp-defs ) )
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2
	)
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	introspection? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		dev-lang/perl
		dev-libs/libxslt
	)
	vala? ( $(vala_depend) )
	test? (
		>=dev-libs/jansson-2.7
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	if use introspection; then
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi
	if use test; then
		python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	if use connection-sharing; then
		if kernel_is lt 5 1; then
			CONFIG_CHECK="~NF_NAT_IPV4 ~NF_NAT_MASQUERADE_IPV4"
		else
			CONFIG_CHECK="~NF_NAT ~NF_NAT_MASQUERADE"
		fi
		linux-info_pkg_setup
	fi

	if use introspection || use test; then
		python-any-r1_pkg_setup
	fi

	# bug 809695
	if tc-is-clang && use lto; then
		eerror "Clang does not support -flto-partition"
		die "Please use gcc or turn off USE=lto flag when building with clang"
	fi
}

src_prepare() {
	DOC_CONTENTS="To modify system network connections without needing to enter the
		root password, add your user account to the 'plugdev' group."

	default
	use vala && vala_setup

	sed -i \
		-e 's#/usr/bin/sed#/bin/sed#' \
		data/84-nm-drivers.rules \
		|| die
}

meson_nm_program() {
	usex "$1" "-D${2:-$1}=$3" "-D${2:-$1}=no"
}

meson_nm_native_program() {
	multilib_native_usex "$1" "-D${2:-$1}=$3" "-D${2:-$1}=no"
}

multilib_src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}/var"

		-Dsystemdsystemunitdir=$(systemd_get_systemunitdir)
		-Dsystem_ca_path=/etc/ssl/certs
		-Dudev_dir=$(get_udevdir)
		-Ddbus_conf_dir=/usr/share/dbus-1/system.d
		-Dkernel_firmware_dir=/lib/firmware
		-Diptables=/sbin/iptables
		-Dnft=/sbin/nft
		-Ddnsmasq=/usr/sbin/dnsmasq

		-Ddist_version=${PVR}
		$(meson_native_use_bool policykit polkit)
		$(meson_native_use_bool policykit config_auth_polkit_default)
		-Dmodify_system=true
		-Dpolkit_agent_helper_1=/usr/lib/polkit-1/polkit-agent-helper-1
		$(meson_native_use_bool selinux)
		$(meson_native_use_bool systemd systemd_journal)
		-Dhostname_persist=gentoo
		-Dlibaudit=$(multilib_native_usex audit)

		$(meson_native_use_bool wext)
		$(meson_native_use_bool wifi)
		$(meson_native_use_bool iwd)
		$(meson_native_use_bool ppp)
		-Dpppd=/usr/sbin/pppd
		$(meson_native_use_bool modemmanager modem_manager)
		$(meson_native_use_bool ofono)
		$(meson_native_use_bool concheck)
		$(meson_native_use_bool teamd teamdctl)
		$(meson_native_use_bool ovs)
		$(meson_native_use_bool tools nmcli)
		$(meson_native_use_bool tools nmtui)
		$(meson_native_use_bool tools nm_cloud_setup)
		$(meson_native_use_bool bluetooth bluez5_dun)
		-Debpf=true

		-Dconfig_wifi_backend_default=$(multilib_native_usex iwd iwd default)
		-Dconfig_plugins_default=keyfile
		-Difcfg_rh=false
		-Difupdown=false

		$(meson_nm_native_program resolvconf "" /sbin/resolvconf)
		-Dnetconfig=no
		-Dconfig_dns_rc_manager_default=auto

		$(meson_nm_program dhclient "" /sbin/dhclient)
		-Ddhcpcanon=no
		$(meson_nm_program dhcpcd "" /sbin/dhcpcd)

		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapi)
		$(meson_native_use_bool gtk-doc docs)
		-Dtests=$(multilib_native_usex test)
		$(meson_native_true firewalld_zone)
		-Dmore_asserts=0
		$(meson_use debug more_logging)
		-Dvalgrind=no
		-Dvalgrind_suppressions=
		-Dld_gc=false
		$(meson_native_use_bool psl libpsl)
		-Dqt=false

		$(meson_use lto b_lto)
	)

	if multilib_is_native_abi && use systemd; then
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=systemd )
		emesonargs+=( -Dsuspend_resume=systemd )
	elif multilib_is_native_abi && use elogind; then
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=elogind )
		emesonargs+=( -Dsuspend_resume=elogind )
	else
		emesonargs+=( -Dsession_tracking_consolekit=false )
		emesonargs+=( -Dsession_tracking=no )
		emesonargs+=( -Dsuspend_resume=auto )
	fi

	if multilib_is_native_abi && use syslog; then
		emesonargs+=( -Dconfig_logging_backend_default=syslog )
	elif multilib_is_native_abi && use systemd; then
		emesonargs+=( -Dconfig_logging_backend_default=journal )
	else
		emesonargs+=( -Dconfig_logging_backend_default=default )
	fi

	if multilib_is_native_abi && use dhclient; then
		emesonargs+=( -Dconfig_dhcp_default=dhclient )
	elif multilib_is_native_abi && use dhcpcd; then
		emesonargs+=( -Dconfig_dhcp_default=dhcpcd )
	else
		emesonargs+=( -Dconfig_dhcp_default=internal )
	fi

	if use nss; then
		emesonargs+=( -Dcrypto=nss )
	else
		emesonargs+=( -Dcrypto=gnutls )
	fi

	if use tools ; then
		emesonargs+=( -Dreadline=$(usex libedit libedit libreadline) )
	else
		emesonargs+=( -Dreadline=none )
	fi

	# Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	if use ppp; then
		local PPPD_VER=`best_version net-dialup/ppp`
		PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
		PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
		emesonargs+=( -Dpppd_plugin_dir=/usr/$(get_libdir)/pppd/${PPPD_VER} )
	fi

	meson_src_configure
}

multilib_src_test() {
	if use test && multilib_is_native_abi; then
		python_setup
		virtx meson_src_test
	fi
}

multilib_src_install() {
	meson_src_install
	if ! multilib_is_native_abi; then
		rm -r "${ED}"/{etc,usr/{bin,lib/NetworkManager,share},var} || die
	fi
}

multilib_src_install_all() {
	! use systemd && readme.gentoo_create_doc

	newinitd "${FILESDIR}/init.d.NetworkManager-r2" NetworkManager
	newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager

	# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d

	# Provide openrc net dependency only when nm is connected
	exeinto /etc/NetworkManager/dispatcher.d
	newexe "${FILESDIR}/10-openrc-status-r4" 10-openrc-status
	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
		-i "${ED}/etc/NetworkManager/dispatcher.d/10-openrc-status" || die

	keepdir /etc/NetworkManager/system-connections
	chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* # bug #383765, upstream bug #754594

	# Allow users in plugdev group to modify system connections
	insinto /usr/share/polkit-1/rules.d/
	doins "${FILESDIR}"/01-org.freedesktop.NetworkManager.settings.modify.system.rules

	insinto /usr/lib/NetworkManager/conf.d #702476
	doins "${S}"/examples/nm-conf.d/31-mac-addr-change.conf

	if use iwd; then
		# This goes to $nmlibdir/conf.d/ and $nmlibdir is '${prefix}'/lib/$PACKAGE, thus always lib, not get_libdir
		cat <<-EOF > "${ED}"/usr/lib/NetworkManager/conf.d/iwd.conf || die
		[device]
		wifi.backend=iwd
		EOF
	fi

	mv "${ED}"/usr/share/doc/{NetworkManager/examples/,${PF}} || die
	rmdir "${ED}"/usr/share/doc/NetworkManager || die

	# Empty
	rmdir "${ED}"/var{/lib{/NetworkManager,},} || die
}

pkg_postinst() {
	udev_reload

	systemd_reenable NetworkManager.service
	! use systemd && readme.gentoo_print_elog

	if [[ -e "${EROOT}/etc/NetworkManager/nm-system-settings.conf" ]]; then
		ewarn "The ${PN} system configuration file has moved to a new location."
		ewarn "You must migrate your settings from ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
		ewarn "to ${EROOT}/etc/NetworkManager/NetworkManager.conf"
		ewarn
		ewarn "After doing so, you can remove ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
	fi

	# NM fallbacks to plugin specified at compile time (upstream bug #738611)
	# but still show a warning to remember people to have cleaner config file
	if [[ -e "${EROOT}/etc/NetworkManager/NetworkManager.conf" ]]; then
		if grep plugins "${EROOT}/etc/NetworkManager/NetworkManager.conf" | grep -q ifnet; then
			ewarn
			ewarn "You seem to use 'ifnet' plugin in ${EROOT}/etc/NetworkManager/NetworkManager.conf"
			ewarn "Since it won't be used, you will need to stop setting ifnet plugin there."
			ewarn
		fi
	fi

	# NM shows lots of errors making nmcli almost unusable, bug #528748 upstream bug #690457
	if grep -r "psk-flags=1" "${EROOT}"/etc/NetworkManager/; then
		ewarn "You have psk-flags=1 setting in above files, you will need to"
		ewarn "either reconfigure affected networks or, at least, set the flag"
		ewarn "value to '0'."
	fi

	if use dhclient || use dhcpcd; then
		ewarn "You have enabled USE=dhclient and/or USE=dhcpcd, but NetworkManager since"
		ewarn "version 1.20 defaults to the internal DHCP client. If the internal client"
		ewarn "works for you, and you're happy with, the alternative USE flags can be"
		ewarn "disabled. If you want to use dhclient or dhcpcd, then you need to tweak"
		ewarn "the main.dhcp configuration option to use one of them instead of internal."
	fi
}

pkg_postrm() {
	udev_reload
}

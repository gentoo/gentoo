# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson linux-info python-any-r1 systemd udev vala

DESCRIPTION="A set of co-operative tools that make networking simple and straightforward"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"
SRC_URI="https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/archive/${PV}/NetworkManager-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0" # add subslot if libnm-util.so.2 or libnm-glib.so.4 bumps soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="audit bluetooth +concheck connection-sharing consolekit +dhclient dhcpcd "
IUSE+="debug elogind examples +gnutls gtk-doc introspection iwd json kernel_linux "
IUSE+="libpsl lto modemmanager nss ofono ovs +policykit ppp resolvconf selinux "
IUSE+="syslog systemd teamd test +tools vala wext +wifi"

REQUIRED_USE="
	gtk-doc? ( introspection )
	iwd? ( wifi )
	vala? ( introspection )
	^^ ( gnutls nss )
	?? ( consolekit elogind systemd )
	?? ( dhclient dhcpcd )
	?? ( syslog systemd )
"

DEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	net-libs/libndp
	sys-apps/dbus
	sys-kernel/linux-headers
	virtual/libudev
	audit? ( sys-process/audit )
	bluetooth? ( net-wireless/bluez )
	concheck? ( net-misc/curl )
	connection-sharing? (
		net-dns/dnsmasq[dbus,dhcp]
		net-firewall/iptables
	)
	consolekit? ( sys-auth/consolekit )
	dhclient? ( net-misc/dhcp[client] )
	dhcpcd? ( net-misc/dhcpcd )
	elogind? ( sys-auth/elogind )
	gnutls? (
		dev-libs/libgcrypt:0=
		net-libs/gnutls
	)
	introspection? ( dev-libs/gobject-introspection:= )
	json? ( dev-libs/jansson )
	libpsl? ( net-libs/libpsl )
	modemmanager? (
		net-misc/mobile-broadband-provider-info
		net-misc/modemmanager
	)
	nss? ( dev-libs/nss )
	ofono? ( net-misc/ofono )
	ovs? ( dev-libs/jansson )
	policykit? ( sys-auth/polkit )
	ppp? ( net-dialup/ppp[ipv6] )
	resolvconf? ( net-dns/openresolv )
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd:= )
	teamd? (
		dev-libs/jansson
		net-misc/libteam
	)
	tools? (
		dev-libs/newt
		sys-libs/ncurses
		sys-libs/readline:0=
	)
"
RDEPEND="${DEPEND}
	acct-group/plugdev
	|| (
		net-analyzer/arping
		net-misc/iputils[arping(+)]
	)
	wifi? (
		iwd? ( net-wireless/iwd )
		!iwd? ( net-wireless/wpa_supplicant[dbus] )
	)
"
BDEPEND="dev-util/intltool
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
	sys-devel/gettext
	virtual/pkgconfig
	introspection? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		dev-libs/libxslt
		dev-lang/perl
	)
	vala? ( $(vala_depend) )
"

S="${WORKDIR}"/NetworkManager-${PV}

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-1.20.6-dont_call_helpers_with_full_paths.patch"
)

python_check_deps() {
	if use introspection; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi

	if use test; then
		has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	fi
}

sysfs_deprecated_check() {
	ebegin "Checking for SYSFS_DEPRECATED support"

	if { linux_chkconfig_present SYSFS_DEPRECATED_V2; }; then
		eerror "Please disable SYSFS_DEPRECATED_V2 support in your kernel config and recompile "
		eerror "your kernel or NetworkManager will not work correctly."
		eerror "See https://bugs.gentoo.org/333639 for more info."
		die "CONFIG_SYSFS_DEPRECATED_V2 support detected!"
	fi
	eend ${?}
}

pkg_pretend() {
	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			sysfs_deprecated_check
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that if CONFIG_SYSFS_DEPRECATED_V2 is set in your kernel .config, "
			ewarn "NetworkManager will not work correctly."
			ewarn "See https://bugs.gentoo.org/333639 for more info."
		fi
	fi
}

pkg_setup() {
	CONFIG_CHECK="~BPF"

	if use connection-sharing; then
		if kernel_is lt 5 1; then
			CONFIG_CHECK="~NF_NAT_IPV4 ~NF_NAT_MASQUERADE_IPV4"
		else
			CONFIG_CHECK="~NF_NAT ~NF_NAT_MASQUERADE"
		fi
	fi

	linux-info_pkg_setup

	# if use introspection || use test; then
	if use introspection; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-D systemdsystemunitdir=$(systemd_get_systemunitdir)
		-D system_ca_path=/etc/ssl/certs
		-D udev_dir=$(get_udevdir)
		-D dbus_conf_dir=/usr/share/dbus-1/system.d
		-D kernel_firmware_dir=/lib/firmware
		-D iptables=/sbin/iptables
		#-D dnsmasq=
		#-D dnssec_trigger=

		-D dist_version=${PVR}
		$(meson_use policykit polkit)
		-D modify_system=true
		$(meson_use policykit polkit_agent)
		$(meson_use policykit config_auth_polkit_default)
		$(meson_use selinux)
		$(meson_use systemd systemd_journal)
		-D hostname_persist=gentoo
		-D libaudit=$(usex audit yes no)

		$(meson_use wext)
		$(meson_use wifi)
		$(meson_use iwd)
		$(meson_use ppp)
		#-D pppd='path to pppd binary'
		#-D pppd_plugin_dir='path to the pppd plugins directory'
		$(meson_use modemmanager modem_manager)
		$(meson_use ofono)
		$(meson_use concheck)
		$(meson_use teamd teamdctl)
		$(meson_use ovs)
		$(meson_use tools nmcli)
		$(meson_use tools nmtui)
		$(meson_use tools nm_cloud_setup)
		$(meson_use bluetooth bluez5_dun)
		-D ebpf=true

		-D config_plugins_default=keyfile
		-D ifcfg_rh=false
		-D ifupdown=false

		$(meson_feature resolvconf)
		-D netconfig=disable
		-D config_dns_rc_manager_default=symlink

		$(meson_feature dhclient)
		-D dhcpcanon=disable
		$(meson_feature dhcpcd)

		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc docs)
		# $(meson_use debug more_asserts)
		-D more_asserts=0
		$(meson_use debug more_logging)
		-D valgrind=no
		-D valgrind_suppressions=
		$(meson_use debug ld_gc)
		$(meson_use libpsl)
		$(meson_use json json_validation)
		-D qt=false

		$(meson_use lto b_lto)
	)

	if use consolekit; then
		emesonargs+=( -D session_tracking_consolekit=true )
		emesonargs+=( -D session_tracking=no )
		emesonargs+=( -D suspend_resume=consolekit )
	elif use systemd; then
		emesonargs+=( -D session_tracking_consolekit=false )
		emesonargs+=( -D session_tracking=systemd )
		emesonargs+=( -D suspend_resume=systemd )
	elif use elogind; then
		emesonargs+=( -D session_tracking_consolekit=false )
		emesonargs+=( -D session_tracking=elogind )
		emesonargs+=( -D suspend_resume=elogind )
	else
		emesonargs+=( -D session_tracking_consolekit=false )
		emesonargs+=( -D session_tracking=none )
		emesonargs+=( -D suspend_resume=auto )
	fi

	if use syslog; then
		emesonargs+=( -D config_logging_backend_default=syslog )
	elif use systemd; then
		emesonargs+=( -D config_logging_backend_default=journal )
	else
		emesonargs+=( -D config_logging_backend_default=default )
	fi

	if use dhclient; then
		emesonargs+=( -D config_dhcp_default=dhclient )
	elif use dhcpcd; then
		emesonargs+=( -D config_dhcp_default=dhcpcd )
	else
		emesonargs+=( -D config_dhcp_default=internal )
	fi

	if use nss; then
		emesonargs+=( -D crypto=nss )
	else
		emesonargs+=( -D crypto=gnutls )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

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
	chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* || die

	# Allow users in plugdev group to modify system connections
	insinto /usr/share/polkit-1/rules.d/
	doins "${FILESDIR}/01-org.freedesktop.NetworkManager.settings.modify.system.rules"

	if use iwd; then
		insinto /usr/lib/NetworkManager/conf.d/
		newins - iwd.conf <<- _EOF_
			[device]
			wifi.backend=iwd
		_EOF_
	fi

	if use examples; then
		dodoc -r "${S}"/examples/

		insinto /usr/lib/NetworkManager/conf.d
		doins "${S}"/examples/nm-conf.d/{30-anon,31-mac-addr-change}.conf

		# Temporary workaround
		cp "${ED}"/usr/share/doc/NetworkManager/examples/server.conf \
			"${ED}"/usr/share/doc/${PF}/examples/ ||
			die "Failed to copy server.conf example."
	fi

	# Temporary workaround,
	# The file will be installed regargless of 'examples' USE.
	rm "${ED}"/usr/share/doc/NetworkManager/examples/server.conf || die
	rm -r "${ED}"/usr/share/doc/NetworkManager || die

	# Empty dirs
	rm -r "${ED}/var" || die
}

pkg_postinst() {
	systemd_reenable NetworkManager.service
}

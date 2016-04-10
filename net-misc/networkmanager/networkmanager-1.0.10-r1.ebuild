# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager"
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit autotools bash-completion-r1 eutils gnome2 linux-info multilib python-any-r1 systemd \
	user readme.gentoo toolchain-funcs vala versionator virtualx udev multilib-minimal

DESCRIPTION="A set of co-operative tools that make networking simple and straightforward"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0" # add subslot if libnm-util.so.2 or libnm-glib.so.4 bumps soname version

IUSE="bluetooth connection-sharing consolekit +dhclient dhcpcd gnutls +introspection \
kernel_linux +nss +modemmanager ncurses +ppp resolvconf selinux systemd teamd test \
vala +wext +wifi zeroconf" # wimax

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ppc64 ~sparc x86"

REQUIRED_USE="
	modemmanager? ( ppp )
	wext? ( wifi )
	^^ ( nss gnutls )
	^^ ( dhclient dhcpcd )
"

# gobject-introspection-0.10.3 is needed due to gnome bug 642300
# wpa_supplicant-0.7.3-r3 is needed due to bug 359271
# TODO: Qt support?
COMMON_DEPEND="
	>=sys-apps/dbus-1.2[${MULTILIB_USEDEP}]
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.37.6:2[${MULTILIB_USEDEP}]
	>=dev-libs/libnl-3.2.8:3=
	>=sys-auth/polkit-0.106
	net-libs/libndp
	>=net-libs/libsoup-2.40:2.4=
	net-misc/iputils
	sys-libs/readline:0
	>=virtual/libgudev-165:=[${MULTILIB_USEDEP}]
	bluetooth? ( >=net-wireless/bluez-5 )
	connection-sharing? (
		net-dns/dnsmasq[dhcp]
		net-firewall/iptables )
	gnutls? (
		dev-libs/libgcrypt:0=[${MULTILIB_USEDEP}]
		net-libs/gnutls:=[${MULTILIB_USEDEP}] )
	modemmanager? ( >=net-misc/modemmanager-0.7.991 )
	ncurses? ( >=dev-libs/newt-0.52.15 )
	nss? ( >=dev-libs/nss-3.11:=[${MULTILIB_USEDEP}] )
	dhclient? ( >=net-misc/dhcp-4[client] )
	dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
	introspection? ( >=dev-libs/gobject-introspection-0.10.3:= )
	ppp? ( >=net-dialup/ppp-2.4.5:=[ipv6] net-dialup/rp-pppoe )
	resolvconf? ( net-dns/openresolv )
	systemd? ( >=sys-apps/systemd-209:0= )
	!systemd? ( || ( sys-power/upower sys-power/upower-pm-utils ) )
	teamd? ( >=net-misc/libteam-1.9 )
	zeroconf? ( net-dns/avahi:=[autoipd] )
"
RDEPEND="${COMMON_DEPEND}
	consolekit? ( sys-auth/consolekit )
	wifi? ( >=net-wireless/wpa_supplicant-0.7.3-r3[dbus] )
"
DEPEND="${COMMON_DEPEND}
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	>=sys-kernel/linux-headers-2.6.29
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pygobject:2[${PYTHON_USEDEP}]')
	)
"

sysfs_deprecated_check() {
	ebegin "Checking for SYSFS_DEPRECATED support"

	if { linux_chkconfig_present SYSFS_DEPRECATED_V2; }; then
		eerror "Please disable SYSFS_DEPRECATED_V2 support in your kernel config and recompile your kernel"
		eerror "or NetworkManager will not work correctly."
		eerror "See https://bugs.gentoo.org/333639 for more info."
		die "CONFIG_SYSFS_DEPRECATED_V2 support detected!"
	fi
	eend $?
}

pkg_pretend() {
	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			sysfs_deprecated_check
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that if CONFIG_SYSFS_DEPRECATED_V2 is set in your kernel .config, NetworkManager will not work correctly."
			ewarn "See https://bugs.gentoo.org/333639 for more info."
		fi

	fi
}

pkg_setup() {
	enewgroup plugdev
}

src_prepare() {
	DOC_CONTENTS="To modify system network connections without needing to enter the
		root password, add your user account to the 'plugdev' group."

	# Force use of /run, avoid eautoreconf, upstream bug #737139, fixed in 'master'
	sed -e 's:$localstatedir/run/:/run/:' -i configure || die

	# Don't build examples, they are not needed and can cause build failure
	sed -e '/^\s*examples\s*\\/d' -i Makefile.{am,in} || die

	# core: fix failure to configure routes due to wrong device-route for IPv4 peer-addresses
	# (from 1.0 branch)
	epatch "${FILESDIR}"/${P}-vpn-routes.patch

	use vala && vala_src_prepare
	epatch_user # don't remove, users often want custom patches for NM
	eautoreconf
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=()

	# Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	if use ppp; then
		local PPPD_VER=`best_version net-dialup/ppp`
		PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
		PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
		myconf+=( --with-pppd-plugin-dir=/usr/$(get_libdir)/pppd/${PPPD_VER} )
	fi

	# unit files directory needs to be passed only when systemd is enabled,
	# otherwise systemd support is not disabled completely, bug #524534
	use systemd && myconf+=( "$(systemd_with_unitdir)" )

	if multilib_is_native_abi; then
		# work-around man out-of-source brokenness, must be done before configure
		mkdir man || die
		find "${S}"/man -name '*.?' -exec ln -s {} man/ ';' || die
	else
		# libnl, libndp are only used for executables, not libraries
		myconf+=( LIB{NL,NDP}_{CFLAGS,LIBS}=' ' )
	fi

	# TODO: enable wimax when we have a libnl:3 compatible revision of it
	# wimax will be removed, bug #522822
	# ifnet plugin always disabled until someone volunteers to actively
	# maintain and fix it
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		--disable-lto \
		--disable-config-plugin-ibft \
		--disable-ifnet \
		--without-netconfig \
		--with-dbus-sys-dir=/etc/dbus-1/system.d \
		--with-udev-dir="$(get_udevdir)" \
		--with-config-plugins-default=keyfile \
		--with-iptables=/sbin/iptables \
		$(multilib_native_with libsoup) \
		$(multilib_native_enable concheck) \
		--with-crypto=$(usex nss nss gnutls) \
		--with-session-tracking=$(multilib_native_usex systemd systemd $(multilib_native_usex consolekit consolekit no)) \
		--with-suspend-resume=$(multilib_native_usex systemd systemd upower) \
		$(multilib_native_use_enable bluetooth bluez5-dun) \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_enable ppp) \
		--disable-wimax \
		$(use_with dhclient) \
		$(use_with dhcpcd) \
		$(multilib_native_use_with modemmanager modem-manager-1) \
		$(multilib_native_use_with ncurses nmtui) \
		$(multilib_native_use_with resolvconf) \
		$(multilib_native_use_with selinux) \
		$(multilib_native_use_enable teamd teamdctl) \
		$(multilib_native_use_enable test tests) \
		$(multilib_native_use_enable vala) \
		--without-valgrind \
		$(multilib_native_use_with wext) \
		$(multilib_native_use_enable wifi) \
		"${myconf[@]}"

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		local d
		for d in api libnm libnm-util libnm-glib; do
			ln -s "${S}"/docs/${d}/html docs/${d}/html || die
		done
	fi
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
	else
		emake all-am
		emake -C include
		emake -C introspection # generated headers, needed for libnm
		emake -C libnm-core
		emake -C libnm
		emake -C libnm-util
		emake -C libnm-glib
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		python_setup
		Xemake check
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		# Install completions at proper place, bug #465100
		gnome2_src_install completiondir="$(get_bashcompdir)"
	else
		emake DESTDIR="${D}" install-am
		emake DESTDIR="${D}" install -C include
		emake DESTDIR="${D}" install -C introspection
		emake DESTDIR="${D}" install -C libnm-core
		emake DESTDIR="${D}" install -C libnm
		emake DESTDIR="${D}" install -C libnm-util
		emake DESTDIR="${D}" install -C libnm-glib
	fi
}

multilib_src_install_all() {
	! use systemd && readme.gentoo_create_doc

	newinitd "${FILESDIR}/init.d.NetworkManager" NetworkManager
	newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager

	# /var/run/NetworkManager is used by some distros, but not by Gentoo
	rmdir -v "${ED}/var/run/NetworkManager" || die "rmdir failed"
	rmdir -v "${ED}/var/run" || die "rmdir failed"

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
	doins "${FILESDIR}/01-org.freedesktop.NetworkManager.settings.modify.system.rules"
}

pkg_postinst() {
	gnome2_pkg_postinst
	! use systemd && readme.gentoo_print_elog

	if [[ -e "${EROOT}etc/NetworkManager/nm-system-settings.conf" ]]; then
		ewarn "The ${PN} system configuration file has moved to a new location."
		ewarn "You must migrate your settings from ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
		ewarn "to ${EROOT}etc/NetworkManager/NetworkManager.conf"
		ewarn
		ewarn "After doing so, you can remove ${EROOT}etc/NetworkManager/nm-system-settings.conf"
	fi

	# The polkit rules file moved to /usr/share
	old_rules="${EROOT}etc/polkit-1/rules.d/01-org.freedesktop.NetworkManager.settings.modify.system.rules"
	if [[ -f "${old_rules}" ]]; then
		case "$(md5sum ${old_rules})" in
		  574d0cfa7e911b1f7792077003060240* )
			# Automatically delete the old rules.d file if the user did not change it
			elog
			elog "Removing old ${old_rules} ..."
			rm -f "${old_rules}" || eerror "Failed, please remove ${old_rules} manually"
			;;
		  * )
			elog "The ${old_rules}"
			elog "file moved to /usr/share/polkit-1/rules.d/ in >=networkmanager-0.9.4.0-r4"
			elog "If you edited ${old_rules}"
			elog "without changing its behavior, you may want to remove it."
			;;
		esac
	fi

	# ifnet plugin was disabled for systemd users with 0.9.8.6 version
	# and for all people with 0.9.10.0-r1 (see ChangeLog for full explanations)
	if use systemd; then
		if ! version_is_at_least 0.9.8.6 ${REPLACING_VERSIONS}; then
			ewarn "Ifnet plugin won't be used with systemd support enabled"
			ewarn "as it is meant to be used with openRC and can cause collisions"
			ewarn "(like bug #485658)."
			ewarn "Because of this, you will likely need to reconfigure some of"
			ewarn "your networks. To do this you can rely on Gnome control center,"
			ewarn "nm-connection-editor or nmtui tools for example once updated"
			ewarn "NetworkManager version is installed."
		fi
	else
		if ! version_is_at_least 0.9.10.0-r1 ${REPLACING_VERSIONS}; then
			ewarn "Ifnet plugin is now disabled because of it being unattended"
			ewarn "and unmaintained for a long time, leading to some unfixed bugs"
			ewarn "and new problems appearing. We will now use upstream 'keyfile'"
			ewarn "plugin."
			ewarn "Because of this, you will likely need to reconfigure some of"
			ewarn "your networks. To do this you can rely on Gnome control center,"
			ewarn "nm-connection-editor or nmtui tools for example once updated"
			ewarn "NetworkManager version is installed."
		fi
	fi

	# NM fallbacks to plugin specified at compile time (upstream bug #738611)
	# but still show a warning to remember people to have cleaner config file
	if [[ -e "${EROOT}etc/NetworkManager/NetworkManager.conf" ]]; then
		if grep plugins "${EROOT}etc/NetworkManager/NetworkManager.conf" | grep -q ifnet; then
			ewarn
			ewarn "You seem to use 'ifnet' plugin in ${EROOT}etc/NetworkManager/NetworkManager.conf"
			ewarn "Since it won't be used, you will need to stop setting ifnet plugin there."
			ewarn
		fi
	fi

	# NM shows lots of errors making nmcli neither unusable, bug #528748 upstream bug #690457
	if grep -r "psk-flags=1" "${EROOT}"/etc/NetworkManager/; then
		ewarn "You have psk-flags=1 setting in above files, you will need to"
		ewarn "either reconfigure affected networks or, at least, set the flag"
		ewarn "value to '0'."
	fi
}

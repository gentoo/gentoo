# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GENTOO_DEPEND_ON_PERL="no"

inherit autotools base eutils linux-info multilib perl-app systemd user

DESCRIPTION="A a daemon which collects system statistic and provides mechanisms to store the values"

HOMEPAGE="http://collectd.org"
SRC_URI="${HOMEPAGE}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib debug kernel_linux kernel_FreeBSD kernel_Darwin perl selinux static-libs"

# The plugin lists have to follow here since they extend IUSE

# Plugins that to my knowledge cannot be supported (eg. dependencies not in gentoo)
COLLECTD_IMPOSSIBLE_PLUGINS="aquaero mic netapp pinba sigrok xmms"

# Plugins that still need some work
COLLECTD_UNTESTED_PLUGINS="amqp apple_sensors genericjmx ipvs lpar modbus redis
	tape write_redis zfs_arc"

# Plugins that have been (compile) tested and can be enabled via COLLECTD_PLUGINS
COLLECTD_TESTED_PLUGINS="aggregation apache apcups ascent battery bind cgroups
	conntrack contextswitch cpu cpufreq csv curl curl_json curl_xml dbi df disk dns
	email entropy ethstat exec filecount fscache gmond hddtemp interface ipmi
	iptables irq java libvirt load logfile lvm madwifi match_empty_counter
	match_hashed match_regex match_timediff match_value mbmon md memcachec memcached
	memory multimeter mysql netlink network network nfs nginx notify_desktop
	notify_email ntpd numa nut olsrd onewire openvpn oracle perl perl ping postgresql
	powerdns processes protocols python python routeros rrdcached rrdcached rrdtool
	sensors serial snmp statsd swap syslog table tail target_notification
	target_replace target_scale target_set tcpconns teamspeak2 ted thermal threshold
	tokyotyrant unixsock uptime users uuid varnish vmem vserver wireless
	write_graphite write_http write_mongodb"

COLLECTD_DISABLED_PLUGINS="${COLLECTD_IMPOSSIBLE_PLUGINS} ${COLLECTD_UNTESTED_PLUGINS}"

COLLECTD_ALL_PLUGINS=${COLLECTD_TESTED_PLUGINS}

for plugin in ${COLLECTD_ALL_PLUGINS}; do
	IUSE="${IUSE} collectd_plugins_${plugin}"
done
unset plugin

# Now come the dependencies.

COMMON_DEPEND="
	dev-libs/libgcrypt:0
	sys-devel/libtool
	perl?					( dev-lang/perl:=[ithreads] )
	collectd_plugins_apache?		( net-misc/curl )
	collectd_plugins_ascent?		( net-misc/curl dev-libs/libxml2 )
	collectd_plugins_bind?			( dev-libs/libxml2 )
	collectd_plugins_curl?			( net-misc/curl )
	collectd_plugins_curl_json?		( net-misc/curl dev-libs/yajl )
	collectd_plugins_curl_xml?		( net-misc/curl dev-libs/libxml2 )
	collectd_plugins_dbi?			( dev-db/libdbi )
	collectd_plugins_dns?			( net-libs/libpcap )
	collectd_plugins_gmond?			( sys-cluster/ganglia )
	collectd_plugins_ipmi?			( >=sys-libs/openipmi-2.0.16-r1 )
	collectd_plugins_iptables?		( >=net-firewall/iptables-1.4.13 )
	collectd_plugins_java?			( virtual/jre dev-java/java-config-wrapper )
	collectd_plugins_libvirt?		( app-emulation/libvirt dev-libs/libxml2 )
	collectd_plugins_lvm?			( sys-fs/lvm2 )
	collectd_plugins_memcachec?		( dev-libs/libmemcached )
	collectd_plugins_mysql?			( >=virtual/mysql-5.0 )
	collectd_plugins_netlink?		( net-libs/libmnl )
	collectd_plugins_nginx?			( net-misc/curl )
	collectd_plugins_notify_desktop?	( x11-libs/libnotify )
	collectd_plugins_notify_email?		( net-libs/libesmtp dev-libs/openssl )
	collectd_plugins_nut?			( sys-power/nut )
	collectd_plugins_onewire?		( sys-fs/owfs )
	collectd_plugins_oracle?		( dev-db/oracle-instantclient-basic )
	collectd_plugins_perl?			( dev-lang/perl:=[ithreads] )
	collectd_plugins_ping?			( net-libs/liboping )
	collectd_plugins_postgresql?		( dev-db/postgresql )
	collectd_plugins_python?		( =dev-lang/python-2* )
	collectd_plugins_routeros?		( net-libs/librouteros )
	collectd_plugins_rrdcached?		( net-analyzer/rrdtool )
	collectd_plugins_rrdtool?		( net-analyzer/rrdtool )
	collectd_plugins_sensors?		( sys-apps/lm_sensors )
	collectd_plugins_snmp?			( net-analyzer/net-snmp )
	collectd_plugins_tokyotyrant?		( net-misc/tokyotyrant )
	collectd_plugins_varnish?		( www-servers/varnish )
	collectd_plugins_write_http?		( net-misc/curl )
	collectd_plugins_write_mongodb?		( dev-libs/mongo-c-driver )

	kernel_FreeBSD? (
		collectd_plugins_disk?		( sys-libs/libstatgrab )
		collectd_plugins_interface?	( sys-libs/libstatgrab )
		collectd_plugins_load?		( sys-libs/libstatgrab )
		collectd_plugins_memory?	( sys-libs/libstatgrab )
		collectd_plugins_swap?		( sys-libs/libstatgrab )
		collectd_plugins_users?		( sys-libs/libstatgrab )
	)"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	kernel_linux? (
		collectd_plugins_vserver?	( sys-kernel/vserver-sources )
	)"

RDEPEND="${COMMON_DEPEND}
	collectd_plugins_syslog?		( virtual/logger )
	selinux?						( sec-policy/selinux-collectd )"

PATCHES=(
	"${FILESDIR}/${PN}-4.10.2"-{libocci,nohal}.patch
	"${FILESDIR}/${PN}-4.10.3"-werror.patch
	"${FILESDIR}/${PN}-5.1.0"-libperl.patch
	"${FILESDIR}/${PN}-5.1.1"-lt.patch
)

# @FUNCTION: collectd_plugin_kernel_linux
# @DESCRIPTION:
# USAGE: <plug-in name> <kernel_options> <severity>
# kernel_options is a list of kernel configurations options; the check tests whether at least
#   one of them is enabled. If no, depending on the third argument an elog, ewarn, or eerror message
#   is emitted.
collectd_plugin_kernel_linux() {
	local multi_opt opt
	if has ${1} ${COLLECTD_ALL_PLUGINS}; then
		if use collectd_plugins_${1}; then
			for opt in ${2}; do
				if linux_chkconfig_present ${opt}; then return 0; fi
			done
			multi_opt=${2//\ /\ or\ }
			case ${3} in
				(info)
					elog "The ${1} plug-in can use kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(warn)
					ewarn "The ${1} plug-in uses kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(error)
					eerror "The ${1} plug-in needs kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(*)
					die "function collectd_plugin_kernel_linux called with invalid third argument"
				;;
			esac
		fi
	fi
}

collectd_linux_kernel_checks() {
	linux-info_pkg_setup

	# battery.c:/proc/pmu/battery_%i
	# battery.c:/proc/acpi/battery
	collectd_plugin_kernel_linux battery ACPI_BATTERY warn

	# cgroups.c:/sys/fs/cgroup/
	collectd_plugin_kernel_linux cgroups CONFIG_CGROUPS warn

	# cpufreq.c:/sys/devices/system/cpu/cpu%d/cpufreq/
	collectd_plugin_kernel_linux cpufreq SYSFS warn
	collectd_plugin_kernel_linux cpufreq CPU_FREQ_STAT warn

	# nfs.c:/proc/net/rpc/nfs
	# nfs.c:/proc/net/rpc/nfsd
	collectd_plugin_kernel_linux nfs NFS_COMMON warn

	# serial.c:/proc/tty/driver/serial
	# serial.c:/proc/tty/driver/ttyS
	collectd_plugin_kernel_linux serial SERIAL_CORE warn

	# swap.c:/proc/meminfo
	collectd_plugin_kernel_linux swap SWAP warn

	# thermal.c:/proc/acpi/thermal_zone
	# thermal.c:/sys/class/thermal
	collectd_plugin_kernel_linux thermal "PROC_FS SYSFS" warn
	collectd_plugin_kernel_linux thermal ACPI_THERMAL warn

	# vmem.c:/proc/vmstat
	collectd_plugin_kernel_linux vmem VM_EVENT_COUNTERS warn

	# uuid.c:/sys/hypervisor/uuid
	collectd_plugin_kernel_linux uuid SYSFS info

	# wireless.c:/proc/net/wireless
	collectd_plugin_kernel_linux wireless "MAC80211 IEEE80211" warn
}

pkg_setup() {
	if use kernel_linux; then
		if linux_config_exists; then
			einfo "Checking your linux kernel configuration:"
			collectd_linux_kernel_checks
		else
			elog "Cannot find a linux kernel configuration. Continuing anyway."
		fi
	fi

	enewgroup collectd
	enewuser collectd -1 -1 /var/lib/collectd collectd
}

src_prepare() {
	base_src_prepare

	# There's some strange prefix handling in the default config file, resulting in
	# paths like "/usr/var/..."
	sed -i -e "s:@prefix@/var:/var:g" src/collectd.conf.in || die

	sed -i -e "s:/etc/collectd/collectd.conf:/etc/collectd.conf:g" contrib/collectd.service || die

	# fix installdirs for perl, bug 444360
	sed -i -e 's/INSTALL_BASE=$(DESTDIR)$(prefix) //' bindings/Makefile.am || die

	rm -r libltdl || die

	eautoreconf
}

src_configure() {
	# Now come the lists of os-dependent plugins. Any plugin that is not listed anywhere here
	# should work independent of the operating system.

	local linux_plugins="battery cpu cpufreq disk entropy ethstat interface iptables ipvs irq load
		memory md netlink nfs numa processes serial swap tcpconns thermal users vmem vserver
		wireless"

	local libstatgrab_plugins="cpu disk interface load memory swap users"
	local bsd_plugins="cpu tcpconns ${libstatgrab_plugins}"

	local darwin_plugins="apple_sensors battery cpu disk interface memory processes tcpconns"

	local osdependent_plugins="${linux_plugins} ${bsd_plugins} ${darwin_plugins}"
	local myos_plugins=""
	if use kernel_linux; then
		einfo "Enabling Linux plugins."
		myos_plugins=${linux_plugins}
	elif use kernel_FreeBSD; then
		einfo "Enabling FreeBSD plugins."
		myos_plugins=${bsd_plugins}
	elif use kernel_Darwin; then
		einfo "Enabling Darwin plugins."
		myos_plugins=${darwin_plugins}
	fi

	# Do we debug?
	local myconf="$(use_enable debug)"

	local plugin

	# Disable what needs to be disabled.
	for plugin in ${COLLECTD_DISABLED_PLUGINS}; do
		myconf+=" --disable-${plugin}"
	done

	# Set enable/disable for each single plugin.
	for plugin in ${COLLECTD_ALL_PLUGINS}; do
		if has ${plugin} ${osdependent_plugins}; then
			# plugin is os-dependent ...
			if has ${plugin} ${myos_plugins}; then
				# ... and available in this os
				myconf+=" $(use_enable collectd_plugins_${plugin} ${plugin})"
			else
				# ... and NOT available in this os
				if use collectd_plugins_${plugin}; then
					ewarn "You try to enable the ${plugin} plugin, but it is not available for this"
					ewarn "kernel. Disabling it automatically."
				fi
				myconf+=" --disable-${plugin}"
			fi
		elif [[ "${plugin}" = "collectd_plugins_perl" ]]; then
			if use collectd_plugins_perl && ! use perl; then
				ewarn "Perl plugin disabled as perl bindings disabled by -perl use flag"
				myconf+= --disable-perl
			else
				myconf+=" $(use_enable collectd_plugins_${plugin} ${plugin})"
			fi
		else
			myconf+=" $(use_enable collectd_plugins_${plugin} ${plugin})"
		fi
	done

	# Need JAVA_HOME for java.
	if use collectd_plugins_java; then
		myconf+=" --with-java=$(java-config -g JAVA_HOME)"
	fi

	# Need libiptc ONLY for iptables. If we try to use it otherwise bug 340109 happens.
	if ! use collectd_plugins_iptables; then
		myconf+=" --with-libiptc=no"
	fi

	if use perl; then
		myconf+=" --with-perl-bindings=INSTALLDIRS=vendor"
	else
		myconf+=" --without-perl-bindings"
	fi

	# No need for v5upgrade
	myconf+=" --disable-target_v5upgrade"

	# Finally, run econf.
	KERNEL_DIR="${KERNEL_DIR}" econf --config-cache --without-included-ltdl $(use_enable static-libs static) --localstatedir=/var ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	perl_delete_localpod

	find "${D}/usr/" -name "*.la" -exec rm -f {} +

	# use collectd_plugins_ping && setcap cap_net_raw+ep ${D}/usr/sbin/collectd
	# we cannot do this yet

	fowners root:collectd /etc/collectd.conf
	fperms u=rw,g=r,o= /etc/collectd.conf

	dodoc AUTHORS ChangeLog NEWS README TODO

	if use contrib ; then
		insinto /usr/share/doc/${PF}
		doins -r contrib
	fi

	keepdir /var/lib/${PN}
	fowners collectd:collectd /var/lib/${PN}

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	systemd_dounit "contrib/${PN}.service"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" collectd

	sed -i -e 's:^.*PIDFile     "/var/run/collectd.pid":PIDFile     "/var/run/collectd/collectd.pid":' "${D}"/etc/collectd.conf || die
	sed -i -e 's:^#	SocketFile "/var/run/collectd-unixsock":#	SocketFile "/var/run/collectd/collectd-unixsock":' "${D}"/etc/collectd.conf || die
	sed -i -e 's:^.*LoadPlugin perl$:# The new, correct way to load the perl plugin -- \n# <LoadPlugin perl>\n#   Globals true\n# </LoadPlugin>:' "${D}"/etc/collectd.conf || die
	sed -i -e 's:^.*LoadPlugin python$:# The new, correct way to load the python plugin -- \n# <LoadPlugin python>\n#   Globals true\n# </LoadPlugin>:' "${D}"/etc/collectd.conf || die
}

collectd_rdeps() {
	if (use collectd_plugins_${1} && ! has_version "${2}"); then
		elog "The ${1} plug-in needs ${2} to be installed locally or remotely to work."
	fi
}

pkg_postinst() {
	collectd_rdeps apcups sys-power/apcupsd
	collectd_rdeps hddtemp app-admin/hddtemp
	collectd_rdeps mbmon sys-apps/xmbmon
	collectd_rdeps memcached ">=net-misc/memcached-1.2.2-r2"
	collectd_rdeps ntpd net-misc/ntp
	collectd_rdeps openvpn ">=net-misc/openvpn-2.0.9"
	collectd_rdeps write_mongodb "dev-db/mongodb"

	echo
	elog "collectd is now started as unprivileged user by default."
	elog "You may want to recheck the configuration."
	elog

	if use collectd_plugins_email; then
		ewarn "The email plug-in is deprecated. To submit statistics please use the unixsock plugin."
	fi
	if use contrib; then
		elog "The scripts in /usr/share/doc/${PF}/collection3 for generating graphs need dev-perl/HTML-Parser,"
		elog "dev-perl/config-general, dev-perl/regexp-common, and net-analyzer/rrdtool[perl] to be installed."
	fi
}

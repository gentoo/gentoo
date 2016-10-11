# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
JAVA_PKG_OPT_USE="collectd_plugins_java"

inherit autotools fcaps flag-o-matic java-pkg-opt-2 linux-info multilib perl-functions python-single-r1 systemd user

DESCRIPTION="Collects system statistics and provides mechanisms to store the values"

HOMEPAGE="https://collectd.org/"
SRC_URI="${HOMEPAGE}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="contrib debug java kernel_Darwin kernel_FreeBSD kernel_linux perl selinux static-libs udev xfs"

# The plugin lists have to follow here since they extend IUSE

# Plugins that don't build (e.g. dependencies not in Gentoo)
# apple_sensors: Requires libIOKit
# aquaero:       Requires aerotools-ng/libaquaero5
# barometer:     Requires libi2c (i2c_smbus_read_i2c_block_data)
# grpc:          Requires libgrpc
# lpar:          Requires libperfstat (AIX only)
# mic:           Requires Intel Many Integrated Core Architecture API
#                (part of Intel's  Xeon Phi software)
# netapp:        Requires libnetapp (http://communities.netapp.com/docs/DOC-1110)
# pf:            Requires BSD packet filter
# pinba:         Requires MySQL Pinba engine (http://pinba.org/)
# tape:          Requires libkstat (Solaris only)
# write_mongodb: https://github.com/collectd/collectd/issues/492
# write_riemann: Requires riemann-c-client
# xmms:          Requires libxmms (v1)
# zone:          Solaris only...
COLLECTD_IMPOSSIBLE_PLUGINS="apple_sensors aquaero barometer grpc lpar mic
	netapp pf pinba tape write_kafka write_mongodb write_riemann xmms
	zone"

# Plugins that have been (compile) tested and can be enabled via COLLECTD_PLUGINS
COLLECTD_TESTED_PLUGINS="aggregation amqp apache apcups ascent battery bind
	ceph cgroups chrony conntrack contextswitch cpu cpufreq cpusleep
	csv curl curl_json curl_xml dbi df disk dns drbd email entropy
	ethstat exec fhcount filecount fscache gmond gps hddtemp interface
	ipc ipmi iptables ipvs irq java lua load logfile log_logstash lvm
	madwifi match_empty_counter match_hashed match_regex match_timediff
	match_value mbmon md memcachec memcached memory modbus mqtt
	multimeter mysql netlink network network nfs nginx notify_desktop
	notify_email notify_nagios ntpd numa nut olsrd onewire openldap
	openvpn oracle perl ping postgresql powerdns processes protocols
	python python redis routeros rrdcached rrdtool sensors serial
	sigrok smart snmp statsd swap syslog table tail tail_csv
	target_notification target_replace target_scale target_set tcpconns
	teamspeak2 ted thermal threshold tokyotyrant turbostat unixsock
	uptime users uuid varnish virt vmem vserver wireless write_graphite
	write_http write_kafka write_log write_redis write_sensu write_tsdb
	xencpu zfs_arc zookeeper"

COLLECTD_DISABLED_PLUGINS="${COLLECTD_IMPOSSIBLE_PLUGINS}"

COLLECTD_ALL_PLUGINS=${COLLECTD_TESTED_PLUGINS}

for plugin in ${COLLECTD_ALL_PLUGINS}; do
	IUSE="${IUSE} collectd_plugins_${plugin}"
done
unset plugin

# Now come the dependencies.

COMMON_DEPEND="
	dev-libs/libgcrypt:=
	dev-libs/libltdl:0=
	perl?					( dev-lang/perl:=[ithreads] )
	udev?					( virtual/udev )
	xfs?					( sys-fs/xfsprogs )
	collectd_plugins_amqp?			( net-libs/rabbitmq-c )
	collectd_plugins_apache?		( net-misc/curl:0= )
	collectd_plugins_ascent?		( net-misc/curl:0= dev-libs/libxml2:2= )
	collectd_plugins_bind?			( dev-libs/libxml2:2= )
	collectd_plugins_ceph?			( dev-libs/yajl:= )
	collectd_plugins_curl?			( net-misc/curl:0= )
	collectd_plugins_curl_json?		( net-misc/curl:0= dev-libs/yajl:= )
	collectd_plugins_curl_xml?		( net-misc/curl:0= dev-libs/libxml2:2= )
	collectd_plugins_dbi?			( dev-db/libdbi )
	collectd_plugins_dns?			( net-libs/libpcap )
	collectd_plugins_gmond?			( sys-cluster/ganglia )
	collectd_plugins_gps?			( sci-geosciences/gpsd )
	collectd_plugins_ipmi?			( >=sys-libs/openipmi-2.0.16-r1 )
	collectd_plugins_iptables?		( >=net-firewall/iptables-1.4.13:0= )
	collectd_plugins_log_logstash?		( dev-libs/yajl:= )
	collectd_plugins_lua?			( dev-lang/lua:0= )
	collectd_plugins_lvm?			( sys-fs/lvm2 )
	collectd_plugins_memcachec?		( dev-libs/libmemcached )
	collectd_plugins_modbus?		( dev-libs/libmodbus )
	collectd_plugins_mqtt?			( app-misc/mosquitto )
	collectd_plugins_mysql?			( >=virtual/mysql-5.0 )
	collectd_plugins_netlink?		( net-libs/libmnl )
	collectd_plugins_nginx?			( net-misc/curl:0= )
	collectd_plugins_notify_desktop?	( x11-libs/libnotify )
	collectd_plugins_notify_email?		( net-libs/libesmtp )
	collectd_plugins_nut?			( >=sys-power/nut-2.7.2-r2 )
	collectd_plugins_openldap?		( net-nds/openldap )
	collectd_plugins_onewire?		( >=sys-fs/owfs-3.1:= )
	collectd_plugins_oracle?		( dev-db/oracle-instantclient-basic )
	collectd_plugins_perl?			( dev-lang/perl:=[ithreads] )
	collectd_plugins_ping?			( net-libs/liboping )
	collectd_plugins_postgresql?		( dev-db/postgresql:= )
	collectd_plugins_python?		( ${PYTHON_DEPS} )
	collectd_plugins_redis?			( dev-libs/hiredis:= )
	collectd_plugins_routeros?		( net-libs/librouteros )
	collectd_plugins_rrdcached?		( net-analyzer/rrdtool:= )
	collectd_plugins_rrdtool?		( net-analyzer/rrdtool:= )
	collectd_plugins_sensors?		( sys-apps/lm_sensors )
	collectd_plugins_sigrok?		( <sci-libs/libsigrok-0.4 )
	collectd_plugins_smart?			( dev-libs/libatasmart )
	collectd_plugins_snmp?			( net-analyzer/net-snmp )
	collectd_plugins_tokyotyrant?		( net-misc/tokyotyrant )
	collectd_plugins_varnish?		( www-servers/varnish )
	collectd_plugins_virt?			( app-emulation/libvirt:= dev-libs/libxml2:2= )
	collectd_plugins_write_http?		( net-misc/curl:0= )
	collectd_plugins_write_kafka?		( >=dev-libs/librdkafka-0.9.0.99:= )
	collectd_plugins_write_redis?		( dev-libs/hiredis:= )
	collectd_plugins_xencpu?		( app-emulation/xen-tools )

	kernel_FreeBSD? (
		collectd_plugins_disk?		( sys-libs/libstatgrab:= )
		collectd_plugins_interface?	( sys-libs/libstatgrab:= )
		collectd_plugins_load?		( sys-libs/libstatgrab:= )
		collectd_plugins_memory?	( sys-libs/libstatgrab:= )
		collectd_plugins_swap?		( sys-libs/libstatgrab:= )
		collectd_plugins_users?		( sys-libs/libstatgrab:= )
	)"

# Enforcing <=sys-kernel/linux-headers-4.4 due to #577846
DEPEND="${COMMON_DEPEND}
	collectd_plugins_iptables?		( <=sys-kernel/linux-headers-4.4 )
	collectd_plugins_java?			( >=virtual/jdk-1.6 )
	virtual/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	collectd_plugins_java?			( >=virtual/jre-1.6 )
	collectd_plugins_syslog?		( virtual/logger )
	selinux?				( sec-policy/selinux-collectd )"

REQUIRED_USE="
	collectd_plugins_python?		( ${PYTHON_REQUIRED_USE} )
	collectd_plugins_smart?			( udev )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.6.0-gentoo.patch
	"${FILESDIR}"/${PN}-5.6.0-issue-1896.patch
	"${FILESDIR}"/${PN}-5.6.0-fix-apache-plugin.patch
)

# @FUNCTION: collectd_plugin_kernel_linux
# @DESCRIPTION:
# USAGE: <plugin name> <kernel_options> <severity>
# kernel_options is a list of kernel configurations options; the check tests whether at least
#   one of them is enabled. If no, depending on the third argument an elog, ewarn, or eerror message
#   is emitted.
collectd_plugin_kernel_linux() {
	local multi_opt opt
	if has ${1} ${COLLECTD_ALL_PLUGINS}; then
		if use collectd_plugins_${1}; then
			for opt in ${2}; do
				if linux_chkconfig_present ${opt}; then
					return 0;
				fi
			done
			multi_opt=${2//\ /\ or\ }
			case ${3} in
				(info)
					elog "The ${1} plugin can use kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(warn)
					ewarn "The ${1} plugin uses kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(error)
					eerror "The ${1} plugin needs kernel features that are disabled now; enable ${multi_opt} in your kernel"
				;;
				(*)
					die "function collectd_plugin_kernel_linux called with invalid third argument"
				;;
			esac
		fi
	fi
}

collectd_linux_kernel_checks() {
	if ! linux_chkconfig_present PROC_FS; then
		ewarn "/proc file system support is disabled, many plugins will not be able to read any statistics from your system unless you enable PROC_FS in your kernel"
	fi

	if ! linux_chkconfig_present SYSFS; then
		ewarn "/sys file system support is disabled, many plugins will not be able to read any statistics from your system unless you enable SYSFS in your kernel"
	fi

	# battery.c: /proc/pmu/battery_%i
	# battery.c: /proc/acpi/battery
	collectd_plugin_kernel_linux battery ACPI_BATTERY warn

	# cgroups.c: /sys/fs/cgroup/
	collectd_plugin_kernel_linux cgroups CGROUPS warn

	# cpufreq.c: /sys/devices/system/cpu/cpu%d/cpufreq/
	collectd_plugin_kernel_linux cpufreq SYSFS warn
	collectd_plugin_kernel_linux cpufreq CPU_FREQ_STAT warn

	# drbd.c: /proc/drbd
	collectd_plugin_kernel_linux drbd BLK_DEV_DRBD warn

	# conntrack.c: /proc/sys/net/netfilter/*
	collectd_plugin_kernel_linux conntrack NETFILTER warn

	# fscache.c: /proc/fs/fscache/stats
	collectd_plugin_kernel_linux fscache FSCACHE warn

	# nfs.c: /proc/net/rpc/nfs
	# nfs.c: /proc/net/rpc/nfsd
	collectd_plugin_kernel_linux nfs NFS_COMMON warn

	# serial.c: /proc/tty/driver/serial
	# serial.c: /proc/tty/driver/ttyS
	collectd_plugin_kernel_linux serial SERIAL_CORE warn

	# swap.c: /proc/meminfo
	collectd_plugin_kernel_linux swap SWAP warn

	# thermal.c: /proc/acpi/thermal_zone
	# thermal.c: /sys/class/thermal
	collectd_plugin_kernel_linux thermal ACPI_THERMAL warn

	# turbostat.c: /dev/cpu/%d/msr
	collectd_plugin_kernel_linux turbostat X86_MSR warn

	# vmem.c: /proc/vmstat
	collectd_plugin_kernel_linux vmem VM_EVENT_COUNTERS warn

	# vserver.c: /proc/virtual
	collectd_plugin_kernel_linux vserver VSERVER warn

	# uuid.c: /sys/hypervisor/uuid
	collectd_plugin_kernel_linux uuid SYSFS info

	# wireless.c: /proc/net/wireless
	collectd_plugin_kernel_linux wireless "WIRELESS MAC80211 IEEE80211" warn

	# zfs_arc.c: /proc/spl/kstat/zfs/arcstats
	collectd_plugin_kernel_linux zfs_arc "SPL ZFS" warn
}

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup

		if linux_config_exists; then
			einfo "Checking your linux kernel configuration:"
			collectd_linux_kernel_checks
		else
			elog "Cannot find a linux kernel configuration. Continuing anyway."
		fi
	fi

	if use collectd_plugins_java; then
		java-pkg-opt-2_pkg_setup
	fi

	use collectd_plugins_python && python-single-r1_pkg_setup

	enewgroup collectd
	enewuser collectd -1 -1 /var/lib/collectd collectd
}

src_prepare() {
	default

	# There's some strange prefix handling in the default config file, resulting in
	# paths like "/usr/var/..."
	sed -i -e "s:@prefix@/var:/var:g" src/collectd.conf.in || die

	# fix installdirs for perl, bug 444360
	sed -i -e 's/INSTALL_BASE=$(DESTDIR)$(prefix) //' bindings/Makefile.am || die

	if use collectd_plugins_java; then
		# Set javac -source and -target flags according to (R)DEPEND.
		sed -i -e "s/\$(JAVAC)/\0 $(java-pkg_javac-args)/g" bindings/java/Makefile.am || die
	fi

	ebegin "Removing bundled libltdl"
	rm -rf libltdl || die
	eend 0

	eautoreconf
}

src_configure() {
	# Now come the lists of os-dependent plugins. Any plugin that is not listed anywhere here
	# should work independent of the operating system.

	local linux_plugins="barometer battery cpu cpufreq disk drbd entropy
		ethstat interface iptables ipvs irq ipc load memory md netlink nfs
		numa processes serial swap tcpconns thermal turbostat users vmem
		wireless zfc_arc"

	local need_libstatgrab=0
	local libstatgrab_plugins="cpu disk interface load memory swap users"
	local bsd_plugins="cpu tcpconns ${libstatgrab_plugins} zfc_arc"

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

	local myconf="--disable-werror"

	# Do we debug?
	myconf+=" $(use_enable debug)"

	# udev support?
	# Required for smart plugin via REQUIRED_USE; Optional for disk plugin
	if use udev; then
		myconf+=" --with-libudev"
	else
		myconf+=" --without-libudev"
	fi

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
				# ... must we link against libstatgrab? Bug #541518
				if use kernel_FreeBSD && has ${plugin} ${libstatgrab_plugins}; then
					einfo "We must link against libstatgrab due to plugin \"${plugin}\" ..."
					need_libstatgrab=1
				fi
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

	if [ "${need_libstatgrab}" -eq 1 ]; then
		myconf+=" --with-libstatgrab"
	else
		myconf+=" --without-libstatgrab"
	fi

	# JAVA_HOME is set by eclasses.
	if use collectd_plugins_java; then
		myconf+=" --with-java"
	fi

	# Need libiptc ONLY for iptables. If we try to use it otherwise bug 340109 happens.
	# lots of libs are only needed for plugins, if they are disabled, also disable the lib
	use collectd_plugins_iptables || myconf+=" --with-libiptc=no"
	use collectd_plugins_openldap || myconf+=" --with-libldap=no"
	use collectd_plugins_redis    || use collectd_plugins_write_redis || myconf+=" --with-libhiredis=no"
	use collectd_plugins_smart    || myconf+=" --with-libatasmart=no"
	use collectd_plugins_gps      || myconf+=" --with-libgps=no"

	if use perl; then
		myconf+=" --with-perl-bindings=INSTALLDIRS=vendor"
	else
		myconf+=" --without-perl-bindings"
	fi

	# No need for v5upgrade
	myconf+=" --disable-target_v5upgrade"

	# Python
	if use collectd_plugins_python; then
		myconf+=" --with-libpython=yes"
		export PYTHON_CONFIG=$(python_get_PYTHON_CONFIG)
	else
		myconf+=" --with-libpython=no"
	fi

	# XFS support
	myconf+=" $(use_enable xfs)"

	# Finally, run econf.
	KERNEL_DIR="${KERNEL_DIR}" econf --config-cache \
		$(use_enable static-libs static) \
		--localstatedir=/var ${myconf}
}

src_install() {
	emake DESTDIR="${D%/}" install

	perl_delete_localpod

	find "${ED}"usr/ -name "*.la" -delete || die

	if use collectd_plugins_java; then
		java-pkg_regjar "${ED}"usr/share/${PN}/java/*.jar
	fi

	fowners root:collectd /etc/collectd.conf
	fperms u=rw,g=r,o= /etc/collectd.conf

	dodoc AUTHORS ChangeLog NEWS README TODO

	if use contrib ; then
		insinto /usr/share/doc/${PF}
		doins -r contrib
	fi

	keepdir /var/lib/${PN}
	fowners collectd:collectd /var/lib/${PN}

	newinitd "${FILESDIR}/${PN}.initd-r1" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r1" ${PN}
	systemd_newunit "contrib/systemd.${PN}.service" ${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	sed -i -e 's:^.*PIDFile     "/var/run/collectd.pid":PIDFile     "/run/collectd/collectd.pid":' "${ED}"etc/collectd.conf || die
	sed -i -e 's:^#	SocketFile "/var/run/collectd-unixsock":#	SocketFile "/run/collectd/collectd.socket":' "${ED}"etc/collectd.conf || die
	sed -i -e 's:^.*LoadPlugin perl$:# The new, correct way to load the perl plugin -- \n# <LoadPlugin perl>\n#   Globals true\n# </LoadPlugin>:' "${ED}"etc/collectd.conf || die
	sed -i -e 's:^.*LoadPlugin python$:# The new, correct way to load the python plugin -- \n# <LoadPlugin python>\n#   Globals true\n# </LoadPlugin>:' "${ED}"etc/collectd.conf || die
}

pkg_postinst() {
	local caps=()
	use collectd_plugins_ceph      && caps+=('cap_dac_override')
	use collectd_plugins_exec      && caps+=('cap_setuid' 'cap_setgid')
	use collectd_plugins_iptables  && caps+=('cap_net_admin')
	use collectd_plugins_filecount && caps+=('cap_dac_read_search')
	use collectd_plugins_turbostat && caps+=('cap_sys_rawio')

	if use collectd_plugins_dns || use collectd_plugins_ping; then
		caps+=('cap_net_raw')
	fi

	if [ ${#caps[@]} -gt 0 ]; then
		local caps_str=$(IFS=","; echo "${caps[*]}")
		fcaps ${caps_str} usr/sbin/collectd
		elog "Capabilities for ${EROOT}usr/sbin/collectd set to:"
		elog "  ${caps_str}+ep"
		elog
	fi

	elog "Note: Collectd is only the collector."
	elog "      You need to install 'data' sources (applications) locally or"
	elog "      remotely on your own."

	elog
	elog "Collectd is configured to run as unprivileged user by default."
	elog "You may want to revisit the configuration."
	elog

	if use collectd_plugins_email; then
		ewarn "The email plug-in is deprecated. To submit statistics please use the unixsock plugin."
	fi

	if use contrib; then
		elog "The scripts in /usr/share/doc/${PF}/collection3 for generating graphs need dev-perl/HTML-Parser,"
		elog "dev-perl/config-general, dev-perl/regexp-common, and net-analyzer/rrdtool[perl] to be installed."
	fi
}

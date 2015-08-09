# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
MY_P="${P/_p/p}"
MY_PV="${MY_P/check_mk-/}"
S="${WORKDIR}/${MY_P}"

inherit eutils toolchain-funcs

DESCRIPTION="General purpose Nagios/Icinga plugin for retrieving data"
HOMEPAGE="http://mathias-kettner.de/check_mk.html"
SRC_URI="http://mathias-kettner.de/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="agent-only apache_status dmi_sysinfo livestatus logwatch mysql
nfsexports oracle postgres smart wato xinetd zypper"
REQUIRED_USE="livestatus? ( !agent-only )
wato? ( !agent-only )"

RDEPEND="${DEPEND}
	( || ( dev-lang/python:2.6 dev-lang/python:2.7 ) )
	wato? ( app-admin/sudo )
	xinetd? ( sys-apps/xinetd )
	!agent-only? ( || ( net-analyzer/nagios-core net-analyzer/icinga ) )
	!agent-only? ( www-servers/apache www-apache/mod_python )"

src_prepare() {
	# modify setup.sh for gentoo
	epatch "${FILESDIR}"/${PN}-1.2.4p3-setup.sh.patch
}

src_configure() {
	if has_version net-analyzer/nagios-core; then
		export mydaemon=nagios
		export nagpipe=/var/nagios/rw/nagios.cmd
		export check_result_path=/var/nagios/spool/checkresults
		export nagios_status_file=/var/nagios/status.dat
		export rrd_path=/var/nagios/perfdata
	else
		export mydaemon=icinga
		export nagpipe=/var/lib/icinga/rw/icinga.cmd
		export check_result_path=/var/lib/icinga/spool/checkresults
		export nagios_status_file=/var/lib/icinga/status.dat
		export rrd_path=/var/lib/icinga/perfdata
	fi

	export nagiosuser=${mydaemon}
	export nagios_binary=/usr/sbin/${mydaemon}
	export nagios_config_file=/etc/${mydaemon}/${mydaemon}.cfg
	export nagconfdir=/etc/${mydaemon}/check_mk.d
	export nagios_startscript=/etc/init.d/${mydaemon}
	export htpasswd_file=/etc/${mydaemon}/htpasswd.users
	export nagios_auth_name="${mydaemon} Access"
	export docdir=/usr/share/doc/${PF}
	export checkmandir=/usr/share/doc/${PF}/checks
	export check_icmp_path=/usr/lib/nagios/plugins/check_icmp
	export wwwuser=apache
	export wwwgroup=apache
	export apache_config_dir=/etc/apache2/modules.d/

	if use livestatus; then
		export enable_livestatus=yes
	else
		export enable_livestatus=no
	fi

	export STRIPPROG=/bin/true
}

src_compile() {
	DESTDIR=${S} ./setup.sh --yes || die "Error while running setup.sh"

	# compile waitmax
	cd "${S}"/usr/share/check_mk/agents || die "Couldn't cd to ${S}/usr/share/check_mk/agents"
	if [[ -f waitmax ]]; then
		rm waitmax || die "Couldn't delete precompiled waitmax file"
	fi
	sed -i -e 's#gcc -s -o waitmax waitmax\.c#gcc -o waitmax waitmax.c#' "${S}"/usr/share/check_mk/agents/Makefile || die "Couldn't modify remove strip from waitmax Makefile"
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die "Couldn't compile waitmax"
}

src_install() {
	if ! use agent-only; then
		# Apache configuration
		insinto /etc/apache2/modules.d
		doins etc/apache2/modules.d/zzz_check_mk.conf

		if use wato; then
			# sudoers configuration
			cat << EOF > "${T}"/check_mk || die
# Needed for WATO - the Check_MK Web Administration Tool
Defaults:apache !requiretty
apache ALL = (root) NOPASSWD: /usr/bin/check_mk --automation *
EOF
			insinto /etc/sudoers.d
			doins "${T}"/check_mk
		fi

		# check_mk configuration
		keepdir /etc/check_mk
		insinto /etc/check_mk
		doins etc/check_mk/main.mk
		doins etc/check_mk/main.mk-${MY_PV}
		doins etc/check_mk/multisite.mk
		doins etc/check_mk/multisite.mk-${MY_PV}
		keepdir /etc/check_mk/conf.d
		insinto /etc/check_mk/conf.d
		doins etc/check_mk/conf.d/README
		keepdir /etc/check_mk/conf.d/wato
		touch "${D}"/etc/check_mk/conf.d/distributed_wato.mk
		keepdir /etc/check_mk/multisite.d
		keepdir /etc/check_mk/multisite.d/wato
		touch "${D}"/etc/check_mk/multisite.d/sites.mk

		insinto /etc/${mydaemon}
		doins etc/${mydaemon}/auth.serials

		# Nagios / Icinga check_mk templates
		insinto /etc/${mydaemon}/check_mk.d
		doins etc/${mydaemon}/check_mk.d/check_mk_templates.cfg

		dobin usr/bin/check_mk
		dobin usr/bin/mkp
		insinto /usr/bin
		doins usr/bin/cmk

		# remove compiled agent_modbus
		if [[ -f ${S}/usr/share/doc/${PF}/treasures/modbus/agent_modbus ]]; then
			rm "${S}"/usr/share/doc/${PF}/treasures/modbus/agent_modbus || die "Couldn't remove precompiled agent_modbus"
		fi

		insinto /usr/share/check_mk
		doins -r usr/share/check_mk/*

		keepdir /var/lib/check_mk/autochecks
		keepdir /var/lib/check_mk/cache
		keepdir /var/lib/check_mk/counters
		keepdir /var/lib/check_mk/logwatch
		keepdir /var/lib/check_mk/notify
		keepdir /var/lib/check_mk/packages
		insinto /var/lib/check_mk/packages
		doins var/lib/check_mk/packages/check_mk
		keepdir /var/lib/check_mk/precompiled
		keepdir /var/lib/check_mk/snmpwalks
		keepdir /var/lib/check_mk/tmp
		keepdir /var/lib/check_mk/wato
		keepdir /var/lib/check_mk/web

		# Update check_mk defaults
		sed -i -e "s#^\(check_mk_automation\s*= 'sudo -u\) portage \(.*\)\$#\1 ${mydaemon} \2#" "${D}"/usr/share/check_mk/modules/defaults || die "Couldn't update check_mk defaults"
		cp "${D}"/usr/share/check_mk/modules/defaults "${D}"/usr/share/check_mk/web/htdocs/defaults.py || die "Couldn't copy check_mk defaults"

		# Change permissions
		fowners -R ${mydaemon}:apache /etc/${mydaemon}/auth.serials
		fperms -R 0660 /etc/${mydaemon}/auth.serials
		fowners -R ${mydaemon}:${mydaemon} /etc/${mydaemon}/check_mk.d
		fperms -R 0775 /etc/${mydaemon}/check_mk.d
		fowners -R root:apache /etc/check_mk/conf.d/wato
		fperms -R 0775 /etc/check_mk/conf.d/wato
		fowners root:apache /etc/check_mk/conf.d/distributed_wato.mk
		fperms 0664 /etc/check_mk/conf.d/distributed_wato.mk
		fowners -R root:apache /etc/check_mk/multisite.d/wato
		fperms -R 0775 /etc/check_mk/multisite.d/wato
		fowners root:apache /etc/check_mk/multisite.d/sites.mk
		fperms 0664 /etc/check_mk/multisite.d/sites.mk
		fowners root:${mydaemon} /var/lib/check_mk/cache
		fperms 0775 /var/lib/check_mk/counters
		fowners -R root:${mydaemon} /var/lib/check_mk/counters
		fperms 0775 /var/lib/check_mk/notify
		fowners -R root:${mydaemon} /var/lib/check_mk/notify
		fperms 0775 /var/lib/check_mk/logwatch
		fowners -R root:${mydaemon} /var/lib/check_mk/logwatch
		fperms 0775 /var/lib/check_mk/cache
		fowners -R root:${mydaemon} /var/lib/check_mk/cache
		fperms -R 0775 /var/lib/check_mk/tmp
		fowners -R root:apache /var/lib/check_mk/tmp
		fperms -R 0775 /var/lib/check_mk/web
		fowners -R root:apache /var/lib/check_mk/web
		fperms -R 0775 /var/lib/check_mk/wato
		fowners -R root:apache /var/lib/check_mk/wato
	fi

	# Install agent related files
	newbin usr/share/check_mk/agents/check_mk_agent.linux check_mk_agent
	dobin usr/share/check_mk/agents/waitmax

	if use xinetd; then
		insinto /etc/xinetd.d
		newins usr/share/check_mk/agents/xinetd.conf check_mk
	fi

	keepdir /usr/lib/check_mk_agent/local
	keepdir /usr/lib/check_mk_agent/plugins

	# Install Livestatus
	if use livestatus; then
		cat << EOF > "${T}"/livestatus.cfg || die
define module{
	module_name		mk-livestatus
	module_type		neb
	path			/usr/lib/check_mk/livestatus.o
	args			/var/lib/${mydaemon}/rw/live
	}
EOF

		insinto /etc/${mydaemon}/modules
		doins "${T}"/livestatus.cfg
		fowners ${mydaemon}:${mydaemon} /etc/${mydaemon}/modules/livestatus.cfg

		insinto /usr/lib/check_mk
		doins usr/lib/check_mk/livestatus.o

		dobin usr/bin/unixcat

		keepdir /usr/share/check_mk/livestatus
	fi

	# Documentation
	if ! use agent-only; then
		dodoc -r usr/share/doc/${PF}/*
		docompress -x /usr/share/doc/${PF}/checks/
	else
		dodoc usr/share/doc/${PF}/AUTHORS usr/share/doc/${PF}/COPYING usr/share/doc/${PF}/ChangeLog
		docompress
	fi

	# Install the check_mk_agent logwatch plugin
	if use logwatch; then
		insinto /etc/check_mk
		doins usr/share/check_mk/agents/logwatch.cfg
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_logwatch
	fi

	# Install the check_mk_agent smart plugin
	if use smart; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/smart
	fi

	# Install the check_mk_agent mysql plugin
	if use mysql; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_mysql
	fi

	# Install the check_mk_agent postgres plugin
	if use postgres; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_postgres
	fi

	# Install the check_mk_agent apache_status plugin
	if use apache_status; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/apache_status
	fi

	# Install the check_mk_agent zypper plugin
	if use zypper; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_zypper
	fi

	# Install the check_mk_agent oracle plugin
	if use oracle; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_oracle
	fi

	# Install the check_mk_agent nfsexports plugin
	if use nfsexports; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/nfsexports
	fi

	# Install the check_mk_agent dmi_sysinfo plugin
	if use dmi_sysinfo; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/dmi_sysinfo
	fi
}

pkg_postinst() {
	if ! use agent-only; then
		elog "IMPORTANT: Please add the following line to your"
		elog "/etc/${mydaemon}/${mydaemon}.cfg, so that"
		elog "${mydaemon} can load your check_mk configuration."
		elog
		elog "  cfg_dir=/etc/${mydaemon}/check_mk.d"
		elog
	fi
	if use wato; then
		elog "INFO: Your webserver needs write access to"
		elog "/etc/${mydaemon}/htpasswd.users!"
		elog "otherwise wato will not function correctly!"
		elog
		elog "chown ${mydaemon}: /etc/${mydaemon}/htpasswd.users"
		elog "chmod 660 /etc/${mydaemon}/htpasswd.users"
		elog
	fi
}

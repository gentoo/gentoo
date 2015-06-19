# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ufw/ufw-0.34_pre805-r2.ebuild,v 1.5 2015/05/16 15:54:48 jmorgan Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit bash-completion-r1 eutils linux-info distutils-r1 systemd

DESCRIPTION="A program used to manage a netfilter firewall"
HOMEPAGE="http://launchpad.net/ufw"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc ~x86"
IUSE="examples ipv6"

DEPEND="sys-devel/gettext"
RDEPEND=">=net-firewall/iptables-1.4[ipv6?]
	!<kde-misc/kcm-ufw-0.4.2
	!<net-firewall/ufw-frontends-0.3.2
"

# tests fail; upstream bug: https://bugs.launchpad.net/ufw/+bug/815982
RESTRICT="test"

PATCHES=(
	# Remove unnecessary build time dependency on net-firewall/iptables.
	"${FILESDIR}"/${PN}-0.33-dont-check-iptables.patch
	# Move files away from /lib/ufw.
	"${FILESDIR}"/${PN}-0.31.1-move-path.patch
	# Remove shebang modification.
	"${FILESDIR}"/${P}-shebang.patch
	# Fix bash completions, bug #526300
	"${FILESDIR}"/${P}-bash-completion.patch
)

pkg_pretend() {
	local CONFIG_CHECK="~PROC_FS
		~NETFILTER_XT_MATCH_COMMENT ~NETFILTER_XT_MATCH_HL
		~NETFILTER_XT_MATCH_LIMIT ~NETFILTER_XT_MATCH_MULTIPORT
		~NETFILTER_XT_MATCH_RECENT ~NETFILTER_XT_MATCH_STATE"

	if kernel_is -ge 2 6 39; then
		CONFIG_CHECK+=" ~NETFILTER_XT_MATCH_ADDRTYPE"
	else
		CONFIG_CHECK+=" ~IP_NF_MATCH_ADDRTYPE"
	fi

	# https://bugs.launchpad.net/ufw/+bug/1076050
	if kernel_is -ge 3 4; then
		CONFIG_CHECK+=" ~NETFILTER_XT_TARGET_LOG"
	else
		CONFIG_CHECK+=" ~IP_NF_TARGET_LOG"
		use ipv6 && CONFIG_CHECK+=" ~IP6_NF_TARGET_LOG"
	fi

	CONFIG_CHECK+=" ~IP_NF_TARGET_REJECT"
	use ipv6 && CONFIG_CHECK+=" ~IP6_NF_TARGET_REJECT"

	check_extra_config

	# Check for default, useful optional features.
	if ! linux_config_exists; then
		ewarn "Cannot determine configuration of your kernel."
		return
	fi

	local nf_nat_ftp_ok="yes"
	local nf_conntrack_ftp_ok="yes"
	local nf_conntrack_netbios_ns_ok="yes"

	linux_chkconfig_present \
		NF_NAT_FTP || nf_nat_ftp_ok="no"
	linux_chkconfig_present \
		NF_CONNTRACK_FTP || nf_conntrack_ftp_ok="no"
	linux_chkconfig_present \
		NF_CONNTRACK_NETBIOS_NS || nf_conntrack_netbios_ns_ok="no"

	# This is better than an essay for each unset option...
	if [[ ${nf_nat_ftp_ok} = no ]] || [[ ${nf_conntrack_ftp_ok} = no ]] \
		|| [[ ${nf_conntrack_netbios_ns_ok} = no ]]
	then
		echo
		local mod_msg="Kernel options listed below are not set. They are not"
		mod_msg+=" mandatory, but they are often useful."
		mod_msg+=" If you don't need some of them, please remove relevant"
		mod_msg+=" module name(s) from IPT_MODULES in"
		mod_msg+=" '${EROOT}etc/default/ufw' before (re)starting ufw."
		mod_msg+=" Otherwise ufw may fail to start!"
		ewarn "${mod_msg}"
		if [[ ${nf_nat_ftp_ok} = no ]]; then
			ewarn "NF_NAT_FTP: for better support for active mode FTP."
		fi
		if [[ ${nf_conntrack_ftp_ok} = no ]]; then
			ewarn "NF_CONNTRACK_FTP: for better support for active mode FTP."
		fi
		if [[ ${nf_conntrack_netbios_ns_ok} = no ]]; then
			ewarn "NF_CONNTRACK_NETBIOS_NS: for better Samba support."
		fi
	fi
}

python_prepare_all() {
	# Set as enabled by default. User can enable or disable
	# the service by adding or removing it to/from a runlevel.
	sed -i 's/^ENABLED=no/ENABLED=yes/' conf/ufw.conf \
		|| die "sed failed (ufw.conf)"

	sed -i "s/^IPV6=yes/IPV6=$(usex ipv6)/" conf/ufw.defaults || die

	# If LINGUAS is set install selected translations only.
	if [[ -n ${LINGUAS+set} ]]; then
		_EMPTY_LOCALE_LIST="yes"
		pushd locales/po > /dev/null || die

		local lang
		for lang in *.po; do
			if ! has "${lang%.po}" ${LINGUAS}; then
				rm "${lang}" || die
			else
				_EMPTY_LOCALE_LIST="no"
			fi
		done

		popd > /dev/null || die
	else
		_EMPTY_LOCALE_LIST="no"
	fi

	distutils-r1_python_prepare_all
}

python_install_all() {
	newconfd "${FILESDIR}"/ufw.confd ufw
	newinitd "${FILESDIR}"/ufw-2.initd ufw
	systemd_dounit "${FILESDIR}/ufw.service"

	exeinto /usr/share/${PN}
	doexe tests/check-requirements

	# users normally would want it
	insinto /usr/share/doc/${PF}/logging/syslog-ng
	doins "${FILESDIR}"/syslog-ng/*

	insinto /usr/share/doc/${PF}/logging/rsyslog
	doins "${FILESDIR}"/rsyslog/*
	doins doc/rsyslog.example

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
	newbashcomp shell-completion/bash ${PN}

	[[ $_EMPTY_LOCALE_LIST != yes ]] && domo locales/mo/*.mo

	distutils-r1_python_install_all
	python_replicate_script "${D}usr/sbin/ufw"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		echo
		elog "To enable ufw, add it to boot sequence and activate it:"
		elog "-- # rc-update add ufw boot"
		elog "-- # /etc/init.d/ufw start"
		echo
		elog "If you want to keep ufw logs in a separate file, take a look at"
		elog "/usr/share/doc/${PF}/logging."
	fi
	if [[ -z ${REPLACING_VERSIONS} ]] \
		|| [[ ${REPLACING_VERSIONS} < 0.34 ]];
	then
		echo
		elog "/usr/share/ufw/check-requirements script is installed."
		elog "It is useful for debugging problems with ufw. However one"
		elog "should keep in mind that the script assumes IPv6 is enabled"
		elog "on kernel and net-firewall/iptables, and fails when it's not."
	fi
	echo
	ewarn "Note: once enabled, ufw blocks also incoming SSH connections by"
	ewarn "default. See README, Remote Management section for more information."
}

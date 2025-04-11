# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit bash-completion-r1 eapi9-ver edo linux-info python-single-r1 systemd

DESCRIPTION="A program used to manage a netfilter firewall"
HOMEPAGE="https://launchpad.net/ufw"
SRC_URI="https://launchpad.net/ufw/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="examples ipv6"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	net-firewall/iptables[ipv6(+)?]
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	sys-devel/gettext
"

PATCHES=(
	# Move files away from /lib/ufw.
	"${FILESDIR}/${P}-move-path.patch"
	# Remove unnecessary build time dependency on net-firewall/iptables.
	"${FILESDIR}/${P}-dont-check-iptables.patch"
	# Remove shebang modification.
	"${FILESDIR}/${P}-shebang.patch"
	# Fix bash completions, bug #526300
	"${FILESDIR}/${PN}-0.36-bash-completion.patch"
	# Strip distutils use
	"${FILESDIR}/${PN}-0.36.1-distutils.patch"
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
	if [[ "${nf_nat_ftp_ok}" == "no" ]] || \
	   [[ "${nf_conntrack_ftp_ok}" == "no" ]] || \
	   [[ "${nf_conntrack_netbios_ns_ok}" == "no" ]]; then
		echo
		local mod_msg="Kernel options listed below are not set. They are not"
		mod_msg+=" mandatory, but they are often useful."
		mod_msg+=" If you don't need some of them, please remove relevant"
		mod_msg+=" module name(s) from IPT_MODULES in"
		mod_msg+=" '${EROOT}/etc/default/ufw' before (re)starting ufw."
		mod_msg+=" Otherwise ufw may fail to start!"
		ewarn "${mod_msg}"
		if [[ "${nf_nat_ftp_ok}" == "no" ]]; then
			ewarn "NF_NAT_FTP: for better support for active mode FTP."
		fi
		if [[ "${nf_conntrack_ftp_ok}" == "no" ]]; then
			ewarn "NF_CONNTRACK_FTP: for better support for active mode FTP."
		fi
		if [[ "${nf_conntrack_netbios_ns_ok}" == "no" ]]; then
			ewarn "NF_CONNTRACK_NETBIOS_NS: for better Samba support."
		fi
	fi
}

src_prepare() {
	default

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
}

src_compile() {
	edo ${EPYTHON} setup.py build
}

src_install() {
	edo ${EPYTHON} setup.py install --prefix="${EPREFIX}/usr" --root="${D}"
	python_fix_shebang "${ED}"
	python_optimize
	einstalldocs

	newconfd "${FILESDIR}"/ufw.confd ufw
	newinitd "${FILESDIR}"/ufw-2.initd ufw
	systemd_dounit "${FILESDIR}/ufw.service"

	pushd "${ED}" || die
	chmod -R 0644 etc/ufw/*.rules || die
	popd || die

	exeinto /usr/share/${PN}
	doexe tests/check-requirements

	# users normally would want it
	insinto "/usr/share/doc/${PF}/logging/syslog-ng"
	doins -r "${FILESDIR}"/syslog-ng/*

	insinto "/usr/share/doc/${PF}/logging/rsyslog"
	doins -r "${FILESDIR}"/rsyslog/*
	doins doc/rsyslog.example

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
	newbashcomp shell-completion/bash "${PN}"

	[[ ${_EMPTY_LOCALE_LIST} != "yes" ]] && domo locales/mo/*.mo
}

pkg_postinst() {
	local found=()
	local apps=( "net-firewall/arno-iptables-firewall"
		"net-firewall/ferm"
		"net-firewall/firehol"
		"net-firewall/firewalld"
		"net-firewall/ipkungfu" )

	for exe in "${apps[@]}"
	do
		if has_version "${exe}"; then
			found+=( "${exe}" )
		fi
	done

	if [[ -n ${found} ]]; then
		echo ""
		ewarn "WARNING: Detected other firewall applications:"
		ewarn "${found[@]}"
		ewarn "If enabled, these applications may interfere with ufw!"
	fi

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		echo ""
		elog "To enable ufw, add it to boot sequence and activate it:"
		elog "-- # rc-update add ufw boot"
		elog "-- # /etc/init.d/ufw start"
		echo
		elog "If you want to keep ufw logs in a separate file, take a look at"
		elog "/usr/share/doc/${PF}/logging."
	fi
	if [[ -z ${REPLACING_VERSIONS} ]] || ver_replacing -lt 0.34; then
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

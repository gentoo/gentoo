# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info systemd

DESCRIPTION="Modify realtime scheduling policy and priority of IRQ handlers"
HOMEPAGE="https://www.rncbc.org/archive/#rtirq"
SRC_URI="https://www.rncbc.org/archive/${P}.tar.gz
	https://www.rncbc.org/archive/old/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# Correct config file path.
	sed -i -e "s:^\(RTIRQ_CONFIG\=\)\(.*\):\1/etc/conf.d/rtirq:" ${PN}.sh || die
	sed -i -e "s:/etc/sysconfig/rtirq:/etc/conf.d/rtirq:" ${PN}.conf || die
	sed -i -e "s:/etc/init.d/rtirq:/usr/bin/rtirq:" ${PN}{,-resume}.service || die

	default
}

src_install() {
	newbin rtirq.sh rtirq
	newinitd "${FILESDIR}"/rtirq.initd rtirq
	newconfd rtirq.conf rtirq
	systemd_dounit rtirq{,-resume}.service
}

pkg_postinst() {
	local kconfig_warn=1
	local cmdline

	if linux-info_get_any_version && linux_config_exists; then
		if linux_chkconfig_present PREEMPT_RT; then
			kconfig_warn=0
		elif linux_chkconfig_present IRQ_FORCED_THREADING; then
			cmdline=$(< /proc/cmdline) || die
			[[ ${cmdline} == *threadirqs* ]] && kconfig_warn=0
		fi
	fi

	if (( ${kconfig_warn} )); then
		ewarn "To use rtirq, you need one of the following kernel configurations:"
		ewarn " - PREEMPT_RT config option enabled (e.g. with sys-kernel/rt-sources);"
		ewarn " - IRQ_FORCED_THREADING config option enabled and 'threadirqs' option"
		ewarn "   added to the kernel cmdline."
	fi
}

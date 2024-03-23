# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-info systemd

DESCRIPTION="Modify realtime scheduling policy and priority of IRQ handlers"
HOMEPAGE="https://www.rncbc.org/archive/#rtirq"
SRC_URI="https://www.rncbc.org/archive/${P}.tar.gz
	https://www.rncbc.org/archive/old/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-apps/util-linux
"

src_prepare() {
	# We install into bin
	sed -i -e "s:/usr/sbin/rtirq:/usr/bin/rtirq:" ${PN}{,-resume}.service || die

	default
}

src_install() {
	newbin rtirq.sh rtirq
	newinitd "${FILESDIR}"/rtirq.initd rtirq
	insinto /etc/
	doins rtirq.conf
	systemd_dounit rtirq{,-resume}.service
}

pkg_postinst() {
	local kconfig_warn=1
	local cmdline
	local ver

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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps

MY_PN="IntelPerformanceCounterMonitor-PCM"
MY_PV="V2.10"
MY_P="${MY_PN}-${MY_PV}.zip"

DESCRIPTION="Intel Performance Counter Monitor - A better way to measure CPU utilization"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-performance-counter-monitor-a-better-way-to-measure-cpu-utilization"
SRC_URI="https://dev.gentoo.org/~idella4/distfiles/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=sys-devel/gcc-4:*"

DEPEND="${RDEPEND}"

CONFIG_CHECK="~X86_MSR ~PERF_EVENTS"
ERROR_X86_MSR="Intel Performance Counter Monitor, requires X86_MSR to be set in kernel config."

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
	newbin pcm.x pcm
	newbin pcm-memory.x pcm-memory
	newbin pcm-msr.x pcm-msr
	newbin pcm-numa.x pcm-numa
	newbin pcm-pcie.x pcm-pcie
	newbin pcm-power.x pcm-power
	newbin pcm-sensor.x pcm-sensor
	newbin pcm-tsx.x pcm-tsx
}

pkg_postinst() {
	fcaps CAP_SYS_RAWIO usr/bin/pcm
	fcaps CAP_SYS_RAWIO usr/bin/pcm-{memory,msr,numa,pcie,power,tsx}
}

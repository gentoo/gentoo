# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator fcaps

MY_PN="IntelPerformanceCounterMonitor"
MY_PV="V2.8"
MY_P="${MY_PN}${MY_PV}.zip"

DESCRIPTION="Intel Performance Counter Monitor - A better way to measure CPU utilization"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-performance-counter-monitor-a-better-way-to-measure-cpu-utilization"
SRC_URI="https://dev.gentoo.org/~dlan/distfiles/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=sys-devel/gcc-4:*"

DEPEND="${RDEPEND}
	sys-apps/sed"

CONFIG_CHECK="~X86_MSR ~PERF_EVENTS"
ERROR_X86_MSR="Intel Performance Counter Monitor, requires X86_MSR to be set in kernel config."

S="${WORKDIR}/IntelPerformanceCounterMonitor${MY_PV}"

src_prepare() {
	sed -i 's/^#CXXFLAGS += -DPCM_USE_PERF/CXXFLAGS += -DPCM_USE_PERF/'  Makefile || die
}

src_install() {
	exeinto /usr/bin
		newexe pcm.x pcm
		newexe pcm-memory.x pcm-memory
		newexe pcm-msr.x pcm-msr
		newexe pcm-numa.x pcm-numa
		newexe pcm-pcie.x pcm-pcie
		newexe pcm-power.x pcm-power
		newexe pcm-sensor.x pcm-sensor
		newexe pcm-tsx.x pcm-tsx
}

pkg_postinst() {
	fcaps CAP_SYS_RAWIO usr/bin/pcm
	fcaps CAP_SYS_RAWIO usr/bin/pcm-{memory,msr,numa,pcie,power,tsx}
}

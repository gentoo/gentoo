# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils linux-info
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/fenrus75/powertop.git"
	inherit git-r3 autotools
	SRC_URI=""
else
	MY_P="${PN}-v${PV}"
	SRC_URI="https://01.org/sites/default/files/downloads/${PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="tool that helps you find what software is using the most power"
HOMEPAGE="https://01.org/powertop/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls unicode X"

COMMON_DEPEND="
	dev-libs/libnl:3
	sys-apps/pciutils
	sys-libs/ncurses:=[unicode?]
"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"
RDEPEND="
	${COMMON_DEPEND}
	X? ( x11-apps/xset )
	virtual/libintl
"

pkg_setup() {
	CONFIG_CHECK="
		~X86_MSR
		~DEBUG_FS
		~PERF_EVENTS
		~TRACEPOINTS
		~NO_HZ_IDLE
		~HIGH_RES_TIMERS
		~HPET_TIMER
		~CPU_FREQ_STAT
		~CPU_FREQ_GOV_ONDEMAND
		~FTRACE
		~BLK_DEV_IO_TRACE
		~TRACING
	"
	ERROR_KERNEL_X86_MSR="X86_MSR is not enabled in the kernel, you almost certainly need it"
	ERROR_KERNEL_DEBUG_FS="DEBUG_FS is not enabled in the kernel, you almost certainly need it"
	ERROR_KERNEL_PERF_EVENTS="PERF_EVENTS should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_TRACEPOINTS="TRACEPOINTS should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_NO_HZ_IDLE="NO_HZ_IDLE should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_HIGH_RES_TIMERS="HIGH_RES_TIMERS should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_HPET_TIMER="HPET_TIMER should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_CPU_FREQ_STAT="CPU_FREQ_STAT should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_CPU_FREQ_GOV_ONDEMAND="CPU_FREQ_GOV_ONDEMAND should be enabled in the kernel for full powertop function"
	ERROR_KERNEL_FTRACE="FTRACE needs to be turned on to enable BLK_DEV_IO_TRACE"
	ERROR_KERNEL_BLK_DEV_IO_TRACE="BLK_DEV_IO_TRACE needs to be turned on to enable other config options"
	ERROR_KERNEL_TRACING="TRACING should be enabled in the kernel for full powertop function"
	linux-info_pkg_setup
	if linux_config_exists; then
		if kernel_is -lt 3 7 0; then
			if linux_chkconfig_present SND_HDA_INTEL; then
				CONFIG_CHECK="~SND_HDA_POWER_SAVE"
				ERROR_KERNEL_SND_HDA_POWER_SAVE="SND_HDA_POWER_SAVE should be enabled in the kernel for full powertop function"
				check_extra_config
			fi
		fi
		if kernel_is -lt 3 9 0; then
			CONFIG_CHECK="~EVENT_POWER_TRACING_DEPRECATED"
			ERROR_KERNEL_EVENT_POWER_TRACING_DEPRECATED="EVENT_POWER_TRACING_DEPRECATED should be enabled in the kernel for full powertop function"
			check_extra_config
		fi
		if kernel_is -lt 3 19; then
			CONFIG_CHECK="~PM_RUNTIME"
			ERROR_KERNEL_PM_RUNTIME="PM_RUNTIME should be enabled in the kernel for full powertop function"
			check_extra_config
		else
			CONFIG_CHECK="~PM"
			ERROR_KERNEL_PM="PM should be enabled in the kernel for full powertop function"
			check_extra_config
		fi
		if kernel_is -lt 4 11; then
			CONFIG_CHECK="~TIMER_STATS"
			ERROR_KERNEL_TIMER_STATS="TIMER_STATS should be enabled in the kernel for full powertop function"
			check_extra_config
		fi
	fi
}

src_prepare() {
	default
	if [[ ${PV} == "9999" ]] ; then
		chmod +x scripts/version || die "Failed to make 'scripts/version' executable"
		scripts/version || die "Failed to extract version information"
		eautoreconf
	fi
}

src_configure() {
	export ac_cv_search_delwin=$(usex unicode -lncursesw -lncurses)
	econf $(use_enable nls)
}

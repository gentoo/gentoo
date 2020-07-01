# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-mod versionator

MY_P="${P/_rc/-rc}"
MY_SLOT="$(get_version_component_range 1-2)"

DESCRIPTION="LTTng Kernel Tracer Modules"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="amd64 x86"
IUSE=""

BUILD_TARGETS="default"

CONFIG_CHECK="MODULES KALLSYMS HIGH_RES_TIMERS TRACEPOINTS
	~HAVE_SYSCALL_TRACEPOINTS ~PERF_EVENTS ~EVENT_TRACING ~KPROBES KRETPROBES"

MODULE_NAMES="true"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if kernel_is lt 2 6 27; then
		eerror "${PN} require Linux kernel >= 2.6.27"
		die "Please update your kernel!"
	fi
}

src_install() {
	for i in $(find "${S}" -name "*.ko" -print); do
		local val=${i##${S}/}
		local modules+="${val%%.ko}(misc:) "
	done
	MODULE_NAMES=${modules}

	linux-mod_src_install
	dodoc ChangeLog README.md TODO
}

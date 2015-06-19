# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/lttng-modules/lttng-modules-2.5.1.ebuild,v 1.1 2014/11/22 00:27:57 dlan Exp $

EAPI=5

inherit linux-mod

MY_P="${P/_rc/-rc}"
DESCRIPTION="LTTng Kernel Tracer Modules"
HOMEPAGE="http://lttng.org"
SRC_URI="http://lttng.org/files/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	dodoc ChangeLog README TODO
}

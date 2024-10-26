# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump the following packages together:
# dev-util/lttng-modules
# dev-util/lttng-tools
# dev-util/lttng-ust

inherit linux-mod-r1

MY_P="${P/_rc/-rc}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="LTTng Kernel Tracer Modules"
HOMEPAGE="https://lttng.org"
SRC_URI="https://lttng.org/files/${PN}/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"

KEYWORDS="~amd64 ~x86"

CONFIG_CHECK="MODULES KALLSYMS HIGH_RES_TIMERS TRACEPOINTS
	~HAVE_SYSCALL_TRACEPOINTS ~PERF_EVENTS ~EVENT_TRACING ~KPROBES KRETPROBES"
MODULES_KERNEL_MIN=3.0

src_compile() {
	MODULES_MAKEARGS+=(
		KERNELDIR="${KV_OUT_DIR}"
	)
	emake "${MODULES_MAKEARGS[@]}"
}

src_install() {
	emake "${MODULES_MAKEARGS[@]}" INSTALL_MOD_PATH="${ED}" modules_install
	modules_post_process

	dodoc ChangeLog README.md
}

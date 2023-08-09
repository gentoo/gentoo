# Copyright 1999-2023 Gentoo Authors
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

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="MODULES KALLSYMS HIGH_RES_TIMERS TRACEPOINTS
	~HAVE_SYSCALL_TRACEPOINTS ~PERF_EVENTS ~EVENT_TRACING ~KPROBES KRETPROBES"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if kernel_is lt 3 0; then
		eerror "${PN} require Linux kernel >= 3.0"
		die "Please update your kernel!"
	fi
}

src_compile() {

	local modlist=( lttng-statedump=misc:"${S}":src
		lttng-statedump=misc:"${S}":src
		lttng-clock=misc:"${S}":src
		lttng-wrapper=misc:"${S}":src
		lttng-counter-client-percpu-64-modular=misc:"${S}":src
		lttng-ring-buffer-metadata-mmap-client=misc:"${S}":src
		lttng-ring-buffer-event-notifier-client=misc:"${S}":src
		lttng-counter-client-percpu-32-modular=misc:"${S}":src
		lttng-ring-buffer-client-mmap-overwrite=misc:"${S}":src
		lttng-ring-buffer-client-mmap-discard=misc:"${S}":src
		lttng-ring-buffer-metadata-client=misc:"${S}":src
		lttng-ring-buffer-client-discard=misc:"${S}":src
		lttng-clock-plugin-test=misc:"${S}":src/tests
		lttng-ring-buffer-client-overwrite=misc:"${S}":src
		lttng-tracer=misc:"${S}":src
		lttng-kprobes=misc:"${S}":src/probes
		lttng-test=misc:"${S}":src/tests
		lttng-uprobes=misc:"${S}":src/probes
		lttng-kretprobes=misc:"${S}":src/probes
		lttng-probe-workqueue=misc:"${S}":src/probes
		lttng-probe-regmap=misc:"${S}":src/probes
		lttng-probe-writeback=misc:"${S}":src/probes
		lttng-probe-printk=misc:"${S}":src/probes
		lttng-probe-rcu=misc:"${S}":src/probes
		lttng-probe-compaction=misc:"${S}":src/probes
		lttng-probe-ext4=misc:"${S}":src/probes
		lttng-probe-udp=misc:"${S}":src/probes
		lttng-probe-vmscan=misc:"${S}":src/probes
		lttng-probe-regulator=misc:"${S}":src/probes
		lttng-probe-jbd2=misc:"${S}":src/probes
		lttng-probe-scsi=misc:"${S}":src/probes
		lttng-probe-sock=misc:"${S}":src/probes
		lttng-probe-gpio=misc:"${S}":src/probes
		lttng-probe-skb=misc:"${S}":src/probes
		lttng-probe-napi=misc:"${S}":src/probes
		lttng-probe-block=misc:"${S}":src/probes
		lttng-probe-net=misc:"${S}":src/probes
		lttng-probe-x86-exceptions=misc:"${S}":src/probes
		lttng-probe-x86-irq-vectors=misc:"${S}":src/probes
		lttng-probe-signal=misc:"${S}":src/probes
		lttng-probe-kvm-x86-mmu=misc:"${S}":src/probes
		lttng-probe-kvm-x86=misc:"${S}":src/probes
		lttng-probe-kvm=misc:"${S}":src/probes
		lttng-probe-i2c=misc:"${S}":src/probes
		lttng-probe-power=misc:"${S}":src/probes
		lttng-probe-statedump=misc:"${S}":src/probes
		lttng-probe-module=misc:"${S}":src/probes
		lttng-probe-kmem=misc:"${S}":src/probes
		lttng-probe-timer=misc:"${S}":src/probes
		lttng-probe-irq=misc:"${S}":src/probes
		lttng-counter=misc:"${S}":src/lib
		lttng-probe-sched=misc:"${S}":src/probes
		lttng-lib-ring-buffer=misc:"${S}":src/lib)

	local modargs=( KERNELDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Frequency driver for Intel CPUs with undervolting feature"
HOMEPAGE="https://gitlab.com/linux-phc/phc-intel"
REV="rev${PV#*_p}"
SRC_URI="https://gitlab.com/linux-phc/phc-intel/-/archive/${REV}/${PN}-${REV}.tgz"
S="${WORKDIR}/${PN}-${REV}"

LICENSE="GPL-2"
SLOT="0"
IUSE="experimental systemd"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip test"

CONFIG_CHECK="
	CPU_FREQ
	ACPI_PROCESSOR
"

pkg_setup() {
	linux-mod-r1_pkg_setup

	if linux_chkconfig_builtin X86_ACPI_CPUFREQ; then
		eend 1
		eerror "Kernel driver acpi_cpufreq is compiled into the kernel."
		eerror "Unlike modules, compiled-in drivers cannot be replaced."
		eerror "Please set CONFIG_CPU_X86_ACPI_CPUFREQ=m or n."
		die "Incorrect kernel configuration options"
	fi
}

src_prepare() {
	local PATCHES=()

	if use experimental; then
		PATCHES+=( "${FILESDIR}/${P}"-enable-experimental.patch )
	fi

	default
}

src_compile() {
	local modlist=( phc-intel )
	local modargs=( KERNELSRC=${KV_DIR} )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /etc/modprobe.d
	newins - "${PN}".conf <<-EOF
	blacklist acpi_cpufreq
	EOF

	insinto /etc/modules-load.d
	newins - "${PN}".conf <<-EOF
	phc_intel
	EOF

	insinto /usr/bin
	newbin "${FILESDIR}/${PN}".sh "${PN}"

	insinto /etc/default
	newins "${FILESDIR}/${PN}".conf "${PN}"

	newinitd "${FILESDIR}/init.d.${PN}" "${PN}"

	if use systemd; then
		insinto /usr/lib/systemd/system
		doins "${FILESDIR}/${PN}".service
	fi
}

pkg_postinst() {
	elog "You can enter the desired voltage IDs in /etc/default/phc-intel"
	elog "The \`phc-intel\` command should apply them."
	elog "Booting with the \`nophc\` kernel parameter skips setting voltages."
	elog "Use it in case of failure."
}

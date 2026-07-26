# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="
	amd64? ( https://cdn.geekbench.com/Geekbench-${PV}-Linux.tar.gz )
	arm64? ( https://cdn.geekbench.com/Geekbench-${PV}-LinuxARMPreview.tar.gz )
	riscv? ( https://cdn.geekbench.com/Geekbench-${PV}-LinuxRISCVPreview.tar.gz )
"
S="${WORKDIR}"

LICENSE="geekbench"
SLOT="6"
KEYWORDS="-* amd64 arm64 ~riscv"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench6/geekbench_aarch64
	opt/geekbench6/geekbench_avx2
	opt/geekbench7/geekbench_rv64gc
	opt/geekbench7/geekbench_rv64gcbv
	opt/geekbench6/geekbench_x86_64
	opt/geekbench6/geekbench6
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	local MY_S="Geekbench-${PV}-Linux$(usex arm64 'ARMPreview' '')"
	local MY_S="Geekbench-${PV}-Linux$(usex riscv 'RISCVPreview' '')"

	exeinto /opt/geekbench6
	use amd64 && doexe "${MY_S}"/geekbench_{avx2,x86_64}
	use arm64 && doexe "${MY_S}"/geekbench_aarch64
	use riscv && doexe "${MY_S}"/geekbench_{rv64gc,rv64gcbv}
	doexe "${MY_S}"/geekbench6

	insinto /opt/geekbench6
	doins "${MY_S}"/geekbench.plar "${MY_S}"/geekbench-workload.plar

	dodir /opt/bin
	dosym ../geekbench6/geekbench6 /opt/bin/geekbench6
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench6 -r <email address> <license key>"
}

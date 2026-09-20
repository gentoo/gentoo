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
SLOT="7"
KEYWORDS="-* ~amd64 ~arm64 ~riscv"

RESTRICT="bindist mirror"

BDEPEND="dev-util/patchelf"

QA_PREBUILT="
	opt/geekbench7/geekbench_aarch64
	opt/geekbench7/geekbench_avx2
	opt/geekbench7/geekbench_rv64gc
	opt/geekbench7/geekbench_rv64gcbv
	opt/geekbench7/geekbench_rva23
	opt/geekbench7/geekbench_x86_64
	opt/geekbench7/geekbench7
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_prepare() {
	default

	local suffix=""
	use arm64 && suffix="ARMPreview"
	use riscv && suffix="RISCVPreview"
	local MY_S="Geekbench-${PV}-Linux${suffix}"

	# Fix QA insecure RUNPATHs
	patchelf --remove-rpath "${MY_S}"/geekbench7 || die
	if use amd64; then
		patchelf --remove-rpath "${MY_S}"/geekbench_{avx2,x86_64} || die
	elif use arm64; then
		patchelf --remove-rpath "${MY_S}"/geekbench_aarch64 || die
	else
		patchelf --remove-rpath "${MY_S}"/geekbench_{rv64gc,rv64gcbv,rva23} || die
	fi
}

src_install() {
	local suffix=""
	use arm64 && suffix="ARMPreview"
	use riscv && suffix="RISCVPreview"
	local MY_S="Geekbench-${PV}-Linux${suffix}"

	exeinto /opt/geekbench7
	use amd64 && doexe "${MY_S}"/geekbench_{avx2,x86_64}
	use arm64 && doexe "${MY_S}"/geekbench_aarch64
	use riscv && doexe "${MY_S}"/geekbench_{rv64gc,rv64gcbv,rva23}
	doexe "${MY_S}"/geekbench7

	insinto /opt/geekbench7
	doins "${MY_S}"/geekbench.plxr "${MY_S}"/geekbench-workload.plxr

	dodir /opt/bin
	dosym ../geekbench7/geekbench7 /opt/bin/geekbench7
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench7 -r <email address> <license key>"
}

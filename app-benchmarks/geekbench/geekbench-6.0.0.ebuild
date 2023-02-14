# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="k9ea2vqm"

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="
	amd64? ( https://cdn.geekbench.com/${EGIT_COMMIT}/Geekbench-${PV}-Linux.tar.gz )
	arm64? ( https://cdn.geekbench.com/${EGIT_COMMIT}/Geekbench-${PV}-LinuxARMPreview.tar.gz )
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~arm64"
LICENSE="geekbench"
SLOT="6"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench6/geekbench_aarch64
	opt/geekbench6/geekbench_avx2
	opt/geekbench6/geekbench_x86_64
	opt/geekbench6/geekbench6
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	local MY_S="Geekbench-${PV}-Linux$(usex arm64 'ARMPreview' '')"

	exeinto /opt/geekbench6
	use amd64 && doexe "${MY_S}"/geekbench_avx2 "${MY_S}"/geekbench_x86_64
	use arm64 && doexe "${MY_S}"/geekbench_aarch64
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

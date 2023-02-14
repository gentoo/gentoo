# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="
	amd64? ( https://cdn.geekbench.com/Geekbench-${PV}-Linux.tar.gz )
	arm64? ( https://cdn.geekbench.com/Geekbench-${PV}-LinuxARMPreview.tar.gz )
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~arm64"
LICENSE="geekbench"
SLOT="5"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench5/geekbench_aarch64
	opt/geekbench5/geekbench_armv7
	opt/geekbench5/geekbench_x86_64
	opt/geekbench5/geekbench5
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	local MY_S="Geekbench-${PV}-Linux$(usex arm64 'ARMPreview' '')"

	exeinto /opt/geekbench5
	use amd64 && doexe "${MY_S}"/geekbench_x86_64
	use arm64 && doexe "${MY_S}"/geekbench_aarch64 "${MY_S}"/geekbench_armv7
	doexe "${MY_S}"/geekbench5

	insinto /opt/geekbench5
	doins "${MY_S}"/geekbench.plar

	dodir /opt/bin
	dosym ../geekbench5/geekbench5 /opt/bin/geekbench5
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench5 -r <email address> <license key>"
}

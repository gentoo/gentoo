# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com"
SRC_URI="https://cdn.primatelabs.com/Geekbench-${PV}-LinuxARM.tar.gz"

KEYWORDS="-* arm"
LICENSE="geekbench"
SLOT="2"

RESTRICT="bindist mirror"

S="${WORKDIR}/dist/Geekbench-${PV}-LinuxARM"

QA_PREBUILT="opt/geekbench2/geekbench opt/geekbench2/geekbench_arm_32"

pkg_nofetch() {
	elog "Please download https://cdn.primatelabs.com/${A}"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench2
	doexe geekbench geekbench_arm_32

	insinto /opt/geekbench2
	doins geekbench.plar

	dodir /opt/bin
	dosym ../geekbench2/geekbench /opt/bin/geekbench2
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench2 -r <email address> <license key>"
}

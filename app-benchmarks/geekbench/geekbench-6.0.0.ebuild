# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="k9ea2vqm"

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="https://cdn.geekbench.com/${MY_PV}/Geekbench-${PV}-Linux.tar.gz"
S="${WORKDIR}/Geekbench-${PV}-Linux"

KEYWORDS="-* ~amd64"
LICENSE="geekbench"
SLOT="6"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench6/geekbench_avx
	opt/geekbench6/geekbench6
	opt/geekbench6/geekbench_x86_64
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench6
	doexe geekbench_avx2 geekbench6 geekbench_x86_64

	insinto /opt/geekbench6
	doins geekbench.plar geekbench-workload.plar

	dodir /opt/bin
	dosym ../geekbench6/geekbench6 /opt/bin/geekbench6
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench6 -r <email address> <license key>"
}

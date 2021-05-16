# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com"
SRC_URI="https://cdn.geekbench.com/Geekbench-${PV}-Linux.tar.gz"

KEYWORDS="-* amd64 x86"
LICENSE="geekbench"
SLOT="4"

RESTRICT="bindist mirror"

S="${WORKDIR}/Geekbench-${PV}-Linux"

QA_PREBUILT="
	opt/geekbench4/geekbench4
	opt/geekbench4/geekbench_x86_32
	opt/geekbench4/geekbench_x86_64
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench4
	doexe geekbench4 geekbench_x86_32 geekbench_x86_64

	insinto /opt/geekbench4
	doins geekbench.plar

	dodir /opt/bin
	dosym ../geekbench4/geekbench4 /opt/bin/geekbench4
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench4 -r <email address> <license key>"
}

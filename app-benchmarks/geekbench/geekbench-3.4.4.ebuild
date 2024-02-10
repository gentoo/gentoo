# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com"
SRC_URI="https://cdn.geekbench.com/Geekbench-${PV}-Linux.tar.gz"
S="${WORKDIR}/dist/Geekbench-${PV}-Linux"

KEYWORDS="-* amd64 x86"
LICENSE="geekbench"
SLOT="3"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/geekbench3/geekbench opt/geekbench3/geekbench_x86_32 opt/geekbench3/geekbench_x86_64"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/${PN}3/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench3
	doexe geekbench geekbench_x86_32 geekbench_x86_64

	insinto /opt/geekbench3
	doins geekbench.plar

	dodir /opt/bin
	dosym ../geekbench3/geekbench /opt/bin/geekbench3
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench3 -r <email address> <license key>"
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com"
SRC_URI="https://cdn.primatelabs.com/Geekbench-${PV}-Linux.tar.gz"

KEYWORDS="-* amd64 x86"
LICENSE="geekbench"
SLOT="2"

RESTRICT="bindist mirror"

S="${WORKDIR}/dist/Geekbench-${PV}-Linux"

QA_PREBUILT="opt/geekbench2/geekbench opt/geekbench2/geekbench_x86_32 opt/geekbench2/geekbench_x86_64"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/${PN}2/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench2
	doexe geekbench geekbench_x86_32 geekbench_x86_64

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

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform Benchmark for Android, iOS, Linux, MacOS and Windows"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="https://cdn.geekbench.com/Geekbench-${PV}-Linux.tar.gz"
S="${WORKDIR}/Geekbench-${PV}-Linux"

KEYWORDS="-* ~amd64"
LICENSE="geekbench"
SLOT="5"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench5/geekbench5
	opt/geekbench5/geekbench_x86_64
"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}/download/linux"
	elog "and place it in your DISTDIR directory."
}

src_install() {
	exeinto /opt/geekbench5
	doexe geekbench5 geekbench_x86_64

	insinto /opt/geekbench5
	doins geekbench.plar

	dodir /opt/bin
	dosym ../geekbench5/geekbench5 /opt/bin/geekbench5
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench5 -r <email address> <license key>"
}

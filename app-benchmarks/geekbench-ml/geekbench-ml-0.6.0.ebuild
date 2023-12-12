# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform ML workloads Benchmark"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="amd64? ( https://cdn.geekbench.com/GeekbenchML-${PV}-Linux.tar.gz )"
S="${WORKDIR}/GeekbenchML-${PV}-Linux"

KEYWORDS="-* ~amd64"
LICENSE="geekbench"
SLOT="6"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/geekbench-ml/banff_avx2
	opt/geekbench-ml/banff_x86_64
	opt/geekbench-ml/banff
"

src_install() {
	exeinto /opt/geekbench-ml
	doexe banff{,_avx2,_x86_64}

	insinto /opt/geekbench-ml
	doins banff.plar banff-workload.plar

	dodir /opt/bin
	dosym ../geekbench-ml/banff /opt/bin/geekbench-ml
}

pkg_postinst() {
	elog "If you have purchased a commercial license, you can enter"
	elog "your email address and your license key with the following command:"
	elog "geekbench-ml -r <email address> <license key>"
}

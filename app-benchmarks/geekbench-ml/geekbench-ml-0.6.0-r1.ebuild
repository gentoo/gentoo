# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross-Platform ML workloads Benchmark"
HOMEPAGE="https://www.geekbench.com/"
SRC_URI="amd64? ( https://cdn.geekbench.com/GeekbenchML-${PV}-Linux.tar.gz )"
S="${WORKDIR}/GeekbenchML-${PV}-Linux"

LICENSE="geekbench"
SLOT="6"
KEYWORDS="-* amd64"

RESTRICT="bindist mirror"

BDEPEND="dev-util/patchelf"

QA_PREBUILT="
	opt/geekbench-ml/banff_avx2
	opt/geekbench-ml/banff_x86_64
	opt/geekbench-ml/banff
"

src_prepare() {
	default

	# Fix QA insecure RUNPATHs
	patchelf --remove-rpath banff{,_avx2,_x86_64} || die
}

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

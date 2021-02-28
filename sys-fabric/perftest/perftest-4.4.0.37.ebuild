# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="OpenIB uverbs micro-benchmarks"

HOMEPAGE="https://github.com/linux-rdma/perftest/"
LICENSE="|| ( GPL-2 BSD-2 )"

MY_PV="$(ver_cut 1-2)"-"$(ver_cut 3-4)"

SRC_URI="https://github.com/linux-rdma/perftest/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""
SLOT=0

DEPEND="
	sys-apps/pciutils
	sys-cluster/rdma-core
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

src_prepare() {
	default

	eautoreconf
}


src_install() {
	default

	dodoc README runme
	dobin ib_*
}

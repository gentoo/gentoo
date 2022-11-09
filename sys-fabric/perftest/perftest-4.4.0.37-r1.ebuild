# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

MY_PV="$(ver_cut 1-2)-$(ver_cut 3-4)"

DESCRIPTION="OpenIB uverbs micro-benchmarks"
HOMEPAGE="https://github.com/linux-rdma/perftest/"
SRC_URI="https://github.com/linux-rdma/perftest/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"

DEPEND="
	sys-apps/pciutils
	>=sys-cluster/rdma-core-32.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	dodoc README runme
	dobin ib_*
}

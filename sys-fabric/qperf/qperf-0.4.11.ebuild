# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Measure RDMA and IP performance"
HOMEPAGE="https://www.openfabrics.org/"
SRC_URI="https://github.com/linux-rdma/qperf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

DEPEND="sys-cluster/rdma-core"
RDEPEND="
	${DEPEND}
	!sys-fabric/openib-userspace"

src_prepare() {
	default
	eautoreconf
}

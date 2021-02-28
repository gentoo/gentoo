# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils autotools

HOMEPAGE="https://www.openfabrics.org/"
LICENSE="|| ( GPL-2 BSD-2 )"

SRC_URI="https://github.com/linux-rdma/qperf/archive/v0.4.11.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Measure RDMA and IP performance"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

SLOT=0
DEPEND="
	sys-cluster/rdma-core
	"
RDEPEND="
		!sys-fabric/openib-userspace"

src_prepare() {
	eautoreconf
	eapply_user
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}"
}

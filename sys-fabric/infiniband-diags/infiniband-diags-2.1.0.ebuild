# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFED_VER="4.17-1"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OFED diagnostic programs and scripts needed to diagnose an IB subnet"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs"

DEPEND="sys-fabric/rdma-core:=
	sys-fabric/opensm:${SLOT}"
RDEPEND="${DEPEND}
	!sys-fabric/libibmad"

block_other_ofed_versions

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -r "${ED}/var" || die
}

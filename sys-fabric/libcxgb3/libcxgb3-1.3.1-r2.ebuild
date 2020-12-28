# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB - driver for Chelsio T3-based iWARP (RDMA over IP/ethernet)"
KEYWORDS="amd64 ~x86 ~amd64-linux"

DEPEND="sys-fabric/libibverbs:${SLOT}"
RDEPEND="${DEPEND}"
block_other_ofed_versions

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

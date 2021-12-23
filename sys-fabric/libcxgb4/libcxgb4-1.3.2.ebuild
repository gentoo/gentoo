# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit epatch openib

DESCRIPTION="OpenIB - driver for Chelsio T4-based iWARP (RDMA over IP/ethernet)"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

RDEPEND="sys-fabric/libibverbs:${SLOT}"
DEPEND="${DEPEND}
	elibc_musl? ( sys-libs/queue-standalone )"
block_other_ofed_versions

src_prepare() {
	# bug #713776
	epatch "${FILESDIR}"/${PN}-1.3.2-use-system-queue.patch
	rm src/queue.h || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

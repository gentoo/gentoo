# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB Userspace CM library"
KEYWORDS="amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="sys-fabric/libibverbs:${SLOT}"
DEPEND="${RDEPEND}"
block_other_ofed_versions

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB userspace driver for the PathScale InfiniBand HCAs"
KEYWORDS="amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sys-fabric/libibverbs:${SLOT}"
RDEPEND="${DEPEND}"
block_other_ofed_versions

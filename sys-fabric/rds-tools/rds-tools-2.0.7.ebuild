# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFED_VER="4.17-1"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="1.16"

inherit openib toolchain-funcs

DESCRIPTION="OFED userspace rds-tools"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sys-fabric/rdma-core:="
RDEPEND="${DEPEND}"

block_other_ofed_versions

DOCS=( README )
PATCHES=( "${FILESDIR}"/${P}-qa.patch )

pkg_setup() {
	tc-export CC
}

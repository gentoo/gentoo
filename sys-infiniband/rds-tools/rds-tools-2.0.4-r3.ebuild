# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit base openib toolchain-funcs

DESCRIPTION="OpenIB userspace rds-tools"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sys-infiniband/libibverbs:${SLOT}"
RDEPEND="${DEPEND}
	!sys-infiniband/openib-userspace"
block_other_ofed_versions

DOCS=( README )
PATCHES=( "${FILESDIR}"/${P}-qa.patch )

pkg_setup() {
	tc-export CC
}

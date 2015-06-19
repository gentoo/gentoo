# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/rds-tools/rds-tools-2.0.4-r2.ebuild,v 1.2 2012/10/13 06:48:22 alexxy Exp $

EAPI=4

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
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

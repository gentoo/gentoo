# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/librdmacm/librdmacm-1.0.18.ebuild,v 1.3 2014/08/20 10:44:31 ago Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit eutils openib

DESCRIPTION="OpenIB userspace RDMA CM library"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

DEPEND="sys-infiniband/libibverbs:${SLOT}"
RDEPEND="${DEPEND}
		!sys-infiniband/openib-userspace"
block_other_ofed_versions

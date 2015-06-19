# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/infiniband-diags/infiniband-diags-1.6.4.ebuild,v 1.1 2014/04/16 08:22:28 alexxy Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB diagnostic programs and scripts needed to diagnose an IB subnet"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
	sys-infiniband/libibumad:${SLOT}
	sys-infiniband/libibmad:${SLOT}
	sys-infiniband/opensm:${SLOT}"
RDEPEND="${DEPEND}"
block_other_ofed_versions

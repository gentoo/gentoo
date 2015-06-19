# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/ibacm/ibacm-1.0.8.ebuild,v 1.2 2015/06/04 14:51:54 pacho Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="IB CM pre-connection service application"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="
	sys-infiniband/libibumad:${SLOT}
	sys-infiniband/libibverbs:${SLOT}
"
DEPEND="${RDEPEND}"
block_other_ofed_versions

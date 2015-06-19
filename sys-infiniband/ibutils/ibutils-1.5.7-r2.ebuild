# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/ibutils/ibutils-1.5.7-r2.ebuild,v 1.2 2012/10/13 06:48:20 alexxy Exp $

EAPI="4"

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="0.1.g05a9d1a"
OFED_SNAPSHOT="1"

inherit openib

DESCRIPTION="OpenIB userspace tools"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sys-infiniband/libibverbs:${SLOT}
		>=dev-lang/tk-8.4"
RDEPEND="${DEPEND}
		!sys-infiniband/openib-userspace"

block_other_ofed_versions

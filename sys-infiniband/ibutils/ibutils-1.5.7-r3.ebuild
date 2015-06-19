# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/ibutils/ibutils-1.5.7-r3.ebuild,v 1.1 2014/04/16 08:22:29 alexxy Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
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

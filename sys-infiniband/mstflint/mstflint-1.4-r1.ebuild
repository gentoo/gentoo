# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/mstflint/mstflint-1.4-r1.ebuild,v 1.2 2012/10/13 06:48:19 alexxy Exp $

EAPI="4"

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="1.18.g1adcfbf"
OFED_SNAPSHOT="1"

inherit openib

DESCRIPTION="Mellanox firmware burning application"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
block_other_ofed_versions

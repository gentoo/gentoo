# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/libehca/libehca-1.2.2-r3.ebuild,v 1.1 2014/04/16 08:22:28 alexxy Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="0.1.g69e1a88"
OFED_SNAPSHOT="1"

inherit openib

DESCRIPTION="OpenIB - IBM eServer eHCA Infiniband device driver for Linux on POWER"
KEYWORDS=""
IUSE=""

DEPEND="sys-infiniband/libibverbs:${SLOT}"
RDEPEND="${DEPEND}"
block_other_ofed_versions

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/srptools/srptools-1.0.2.ebuild,v 1.1 2014/04/16 08:22:23 alexxy Exp $

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="Tools for discovering and connecting to SRP CSI targets on InfiniBand fabrics"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
	sys-infiniband/libibverbs:${SLOT}
	sys-infiniband/libibumad:${SLOT}
	"
RDEPEND="${DEPEND}"
block_other_ofed_versions

src_install() {
	default
	newinitd "${FILESDIR}/srpd.initd" srpd
}

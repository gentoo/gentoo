# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/srptools/srptools-0.0.4-r2.ebuild,v 1.2 2012/10/13 06:48:21 alexxy Exp $

EAPI="4"

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="0.1.gce1f64c"
OFED_SNAPSHOT="1"

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

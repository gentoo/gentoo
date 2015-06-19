# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/libibumad/libibumad-1.3.8.ebuild,v 1.3 2014/08/10 20:18:51 slyfox Exp $

EAPI="4"

OFED_VER="3.5"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB User MAD library functions which sit on top of the user MAD modules in the kernel"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="
	sys-infiniband/libibverbs:${SLOT}
	"
RDEPEND="${DEPEND}"
block_other_ofed_versions

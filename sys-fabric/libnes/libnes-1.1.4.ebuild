# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="0"

inherit openib

DESCRIPTION="NetEffect RNIC Userspace Library"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs"

DEPEND="sys-fabric/libibverbs:${SLOT}"
RDEPEND="${DEPEND}
	!sys-fabric/openib-userspace"
block_other_ofed_versions

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || rm -f "${D}"usr/$(get_libdir)/${PN}.la
}

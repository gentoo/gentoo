# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="2_ga8c3e3e_open"
OFED_SNAPSHOT="1"
OFED_SRC_SNAPSHOT="1"

inherit openib udev

DESCRIPTION="OpenIB userspace driver for the PathScale InfiniBand HCAs"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="sys-fabric/libibverbs:${SLOT}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

block_other_ofed_versions

src_prepare() {
	sed -e 's:uname -p:uname -m:g' \
		-e 's:-Werror::g' \
		-i buildflags.mak || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
	udev_dorules "${FILESDIR}"/42-infinipath-psm.rules
}

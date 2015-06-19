# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/yaffs-utils/yaffs-utils-9999.ebuild,v 1.4 2011/09/21 08:16:12 mgorny Exp $

EAPI="2"

EGIT_REPO_URI="git://www.aleph1.co.uk/yaffs"
EGIT_SOURCEDIR=${WORKDIR}

inherit eutils git-2 toolchain-funcs

DESCRIPTION="tools for generating YAFFS images"
HOMEPAGE="http://www.aleph1.co.uk/yaffs/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/utils

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	tc-export CC
}

src_install() {
	dobin mkyaffs || die
	dodoc ../README
}

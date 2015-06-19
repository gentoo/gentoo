# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/yaffs2-utils/yaffs2-utils-9999.ebuild,v 1.5 2012/11/05 07:15:02 vapier Exp $

EAPI="4"

EGIT_REPO_URI="git://www.aleph1.co.uk/yaffs2"
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
	dobin mkyaffsimage mkyaffs2image
	dodoc ../README-linux
}

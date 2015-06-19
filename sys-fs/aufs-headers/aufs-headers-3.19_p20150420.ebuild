# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/aufs-headers/aufs-headers-3.19_p20150420.ebuild,v 1.1 2015/04/20 07:48:22 jlec Exp $

EAPI=5

inherit versionator

DESCRIPTION="User space headers for aufs3"
HOMEPAGE="http://aufs.sourceforge.net/"
# Clone git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-linux.git
# Check aufs release Branch
# Create .config
# make headers_install INSTALL_HDR_PATH=${T}
# find ${T} -type f \( ! -name "*aufs*" \) -delete
# find ${T} -type d -empty -delete
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	doheader -r include/*
}

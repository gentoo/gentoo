# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="User space headers for aufs3"
HOMEPAGE="http://aufs.sourceforge.net/"
# Clone git://aufs.git.sourceforge.net/gitroot/aufs/aufs4-linux.git
# Check aufs release Branch
# Create .config
# make headers_install INSTALL_HDR_PATH=${T}
# find ${T} -type f \( ! -name "*aufs*" \) -delete
# find ${T} -type d -empty -delete
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	doheader -r include/*
}

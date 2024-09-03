# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="User space headers for aufs3"
HOMEPAGE="https://aufs.sourceforge.net/"
# Clone git://aufs.git.sourceforge.net/gitroot/aufs/aufs4-linux.git
# Check aufs release Branch
# Create .config
# make headers_install INSTALL_HDR_PATH=${T}
# find ${T} -type f \( ! -name "*aufs*" \) -delete
# find ${T} -type d -empty -delete
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	doheader -r include/*
}

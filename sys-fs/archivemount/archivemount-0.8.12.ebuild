# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mount archives using libarchive and FUSE"
HOMEPAGE="https://www.cybernoia.de/software/archivemount.html https://github.com/cybernoid/archivemount.git"
SRC_URI="https://www.cybernoia.de/software/archivemount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-arch/libarchive:=
	sys-fs/fuse:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

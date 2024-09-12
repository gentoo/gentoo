# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Support library to access and manipulate FAT12 / FAT16 / FAT32 file systems"
HOMEPAGE="https://libfat.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/libfat/${P}.tar.gz"
S="${WORKDIR}"/fuse-umfuse-fat-0.1

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-libs/glib:2
	sys-fs/fuse:0
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

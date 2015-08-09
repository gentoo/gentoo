# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Support library to access and manipulate FAT12 / FAT16 / FAT32 file systems"
HOMEPAGE="http://libfat.sourceforge.net"
SRC_URI="mirror://sourceforge/libfat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/fuse-umfuse-fat-0.1

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="monitors the forking activity of the kernel and most active processes"
HOMEPAGE="http://hules.free.fr/wmforkplop"
SRC_URI="http://hules.free.fr/wmforkplop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE=""

DEPEND="gnome-base/libgtop
	media-libs/imlib2[X]"
RDEPEND="${DEPEND}"

src_prepare() {
	# Easier to patch configure directly here
	epatch "${FILESDIR}"/${P}-cflags.patch
}

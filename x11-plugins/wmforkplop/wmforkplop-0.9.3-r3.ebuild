# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="monitors the forking activity of the kernel and most active processes"
HOMEPAGE="http://hules.free.fr/wmforkplop"
SRC_URI="http://hules.free.fr/wmforkplop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

DEPEND="gnome-base/libgtop
	media-libs/imlib2[X]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

src_prepare() {
	default
	eautoreconf
}

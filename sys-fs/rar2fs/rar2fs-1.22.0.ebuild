# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A FUSE based filesystem that can mount one or multiple RAR archive(s)"
HOMEPAGE="http://hasse69.github.io/rar2fs/ https://github.com/hasse69/rar2fs"
SRC_URI="https://github.com/hasse69/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=app-arch/unrar-5:=
	sys-fs/fuse"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog"

src_configure() {
	export USER_CFLAGS="${CFLAGS}"

	econf \
		--with-unrar=/usr/include/libunrar \
		$(use_enable debug)
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/rar2fs/rar2fs-1.20.0.ebuild,v 1.2 2015/04/26 01:13:35 radhermit Exp $

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

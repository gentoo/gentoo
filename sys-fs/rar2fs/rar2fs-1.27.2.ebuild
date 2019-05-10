# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A FUSE based filesystem that can mount one or multiple RAR archive(s)"
HOMEPAGE="https://hasse69.github.io/rar2fs/ https://github.com/hasse69/rar2fs"
SRC_URI="https://github.com/hasse69/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=app-arch/unrar-5
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"

src_configure() {
	export USER_CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS} -I/usr/include/libunrar"

	# use static lib to avoid ABI breaks when upstream doesn't follow semantic versioning
	econf \
		--with-unrar="/usr/$(get_libdir)" \
		--enable-static-unrar \
		$(use_enable debug)
}

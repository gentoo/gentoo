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

# Note that upstream unrar sometimes breaks ABI without updating the SONAME
# version so try rebuilding rar2fs if it doesn't work following an unrar
# upgrade.
RDEPEND=">=app-arch/unrar-5:=
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"

src_configure() {
	export USER_CFLAGS="${CFLAGS}"

	econf \
		--with-unrar="${ESYSROOT}"/usr/include/libunrar \
		--disable-static-unrar \
		$(use_enable debug)
}

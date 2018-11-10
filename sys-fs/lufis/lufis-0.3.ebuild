# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Wrapper to use lufs modules with fuse kernel support"
HOMEPAGE="http://fuse.sourceforge.net/"
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="!<sys-fs/lufs-0.9.7-r3
	>=sys-fs/fuse-1.3"

PATCHES=(
	"${FILESDIR}"/lufis-allow-uid-and-gid-addon.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin lufis
	dodoc README ChangeLog

	insinto /usr/include/lufs/
	doins fs.h proto.h
}

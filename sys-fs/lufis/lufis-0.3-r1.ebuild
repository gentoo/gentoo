# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Wrapper to use lufs modules with fuse kernel support"
HOMEPAGE="http://fuse.sourceforge.net/"
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="
	!<sys-fs/lufs-0.9.7-r3
	>=sys-fs/fuse-1.3:0=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/lufis-allow-uid-and-gid-addon.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin lufis
	einstalldocs

	insinto /usr/include/lufs/
	doins fs.h proto.h
}

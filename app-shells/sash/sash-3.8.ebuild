# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A small (static) UNIX Shell"
HOMEPAGE="https://www.canb.auug.org.au/~dbell/"
SRC_URI="https://www.canb.auug.org.au/~dbell/programs/${P}.tar.gz"

LICENSE="sash"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="static"

DEPEND="
	static? ( sys-libs/zlib[static-libs] )
	!static? ( >=sys-libs/zlib-1.2.3 )"
RDEPEND="!static? ( ${DEPEND} )"

src_prepare() {
	eapply "${FILESDIR}"/sash-3.7-builtin.patch

	sed \
		-e "s|-O3|${CFLAGS}|" \
		-e '/strip/d' \
		-i Makefile || die
	sed \
		-e 's:linux/ext2_fs.h:ext2fs/ext2_fs.h:g' \
		-i cmd_chattr.c || die
	eapply_user
}

src_compile() {
	use static && append-ldflags -static

	emake LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin sash
	doman sash.1
	dodoc README
}

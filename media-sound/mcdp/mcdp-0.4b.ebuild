# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A very small console cd player"
HOMEPAGE="http://www.mcmilk.de/projects/mcdp/"
SRC_URI="http://www.mcmilk.de/projects/mcdp/dl/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.4a-dietlibc-fix.patch
	"${FILESDIR}"/${PN}-0.4a-makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin mcdp
	doman mcdp.1
	dodoc doc/{AUTHOR,BUGS,CHANGES,README,THANKS,TODO,WISHLIST,profile.sh}
}

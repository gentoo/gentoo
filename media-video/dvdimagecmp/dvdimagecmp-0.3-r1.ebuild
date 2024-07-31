# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tool to compare a burned DVD with an image to check for errors"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}/${P}.diff"
)

src_compile() {
	append-lfs-flags
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	dobin dvdimagecmp
	dodoc CHANGES README
}

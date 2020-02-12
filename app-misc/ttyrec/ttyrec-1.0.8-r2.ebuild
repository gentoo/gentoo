# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ttyrec provides tools to record and replay a terminal session"
HOMEPAGE="http://0xcc.net/ttyrec/"
SRC_URI="http://0xcc.net/ttyrec/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
PATCHES=( "${FILESDIR}/${P}-flags.patch" )

src_compile() {
	# Bug 106530
	[[ ${CHOST} != *-darwin* ]] && append-cppflags -DSVR4 -D_XOPEN_SOURCE=500
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin tty{rec,play,time}
	doman *.1
	einstalldocs
}

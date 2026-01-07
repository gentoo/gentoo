# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command line MPEG audio/video/system file toolbox"
SRC_URI="https://downloads.sourceforge.net/mpgtx/${P}.tar.gz"
HOMEPAGE="http://mpgtx.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-dont-ignore-cxx-flags.patch
)

src_configure() {
	tc-export CXX
	./configure --parachute || die
}

src_install() {
	dobin mpgtx

	dosym mpgtx /usr/bin/mpgjoin
	dosym mpgtx /usr/bin/mpgsplit
	dosym mpgtx /usr/bin/mpgcat
	dosym mpgtx /usr/bin/mpginfo
	dosym mpgtx /usr/bin/mpgdemux
	dosym mpgtx /usr/bin/tagmp3

	doman man/mpgtx.1 man/tagmp3.1

	dosym mpgtx.1 /usr/share/man/man1/mpgcat.1
	dosym mpgtx.1 /usr/share/man/man1/mpgjoin.1
	dosym mpgtx.1 /usr/share/man/man1/mpginfo.1
	dosym mpgtx.1 /usr/share/man/man1/mpgsplit.1
	dosym mpgtx.1 /usr/share/man/man1/mpgdemux.1

	einstalldocs
}

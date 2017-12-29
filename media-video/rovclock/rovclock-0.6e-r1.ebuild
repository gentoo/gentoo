# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Overclocking utility for ATI Radeon cards"
HOMEPAGE="http://www.hasw.net/linux/"
SRC_URI="http://www.hasw.net/linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	eapply "${FILESDIR}"/${P}-ldflags.patch
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin rovclock
	dodoc ChangeLog README
}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/rovclock/rovclock-0.6e.ebuild,v 1.5 2011/03/18 20:35:48 angelos Exp $

EAPI=3
inherit toolchain-funcs eutils

DESCRIPTION="Overclocking utility for ATI Radeon cards"
HOMEPAGE="http://www.hasw.net/linux/"
SRC_URI="http://www.hasw.net/linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dosbin rovclock || die "dosbin failed"
	dodoc ChangeLog README
}

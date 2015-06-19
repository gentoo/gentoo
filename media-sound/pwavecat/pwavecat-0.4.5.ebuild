# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pwavecat/pwavecat-0.4.5.ebuild,v 1.3 2011/05/07 17:22:54 angelos Exp $

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

IUSE=""

DESCRIPTION="concatenates any number of audio files to stdout"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}/${P}.diff" \
		"${FILESDIR}"/${P}-overflow.patch
}

src_compile() {
	append-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE	-D_LARGEFILE64_SOURCE
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin pwavecat || die
	dodoc CHANGES README
}

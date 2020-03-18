# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extracts and records individual MP3 tracks from shoutcast streams"
HOMEPAGE="http://icecream.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="dev-lang/perl"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc Changelog
}

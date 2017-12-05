# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MIME quoted-printable data encoding and decoding utility"
HOMEPAGE="http://www.fourmilab.ch/webtools/qprint/"
SRC_URI="http://www.fourmilab.ch/webtools/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-macos"
IUSE=""

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	local HTML_DOCS=( *.html )
	default
	dodoc qprint.pdf qprint.w logo.gif
}

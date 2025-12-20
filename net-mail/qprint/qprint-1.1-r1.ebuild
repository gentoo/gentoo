# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MIME quoted-printable data encoding and decoding utility"
HOMEPAGE="https://www.fourmilab.ch/webtools/qprint/"
SRC_URI="https://www.fourmilab.ch/webtools/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	local HTML_DOCS=( *.html )
	default
	dodoc qprint.pdf qprint.w logo.gif
}

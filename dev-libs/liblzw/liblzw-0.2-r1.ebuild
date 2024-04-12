# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="small C library for reading LZW compressed files (.Z)"
HOMEPAGE="https://github.com/vapier/liblzw"
SRC_URI="https://downloads.sourceforge.net/freestdf/${P}.tar.lzma"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ~m68k ~s390 x86"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

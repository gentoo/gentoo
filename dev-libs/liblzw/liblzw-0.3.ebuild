# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="small C library for reading LZW compressed files (.Z)"
HOMEPAGE="https://github.com/vapier/liblzw"
SRC_URI="https://github.com/vapier/liblzw/releases/download/v${PV}/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~m68k ~s390 ~x86"
IUSE="static"

src_configure() {
	econf --disable-werror $(use_enable static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

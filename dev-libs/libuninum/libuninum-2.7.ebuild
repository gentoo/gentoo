# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library for converting unicode strings to numbers and vice versa"
HOMEPAGE="https://billposer.org/Software/libuninum.html"
SRC_URI="https://billposer.org/Software/Downloads/${P}.tar.bz2"

KEYWORDS="amd64 x86"
LICENSE="GPL-2 GPL-2+ LGPL-2 LGPL-2.1"
SLOT="0"

src_configure() {
	local myeconfargs=(
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

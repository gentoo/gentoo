# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Number to number name and money text conversion libraries"
HOMEPAGE="https://github.com/Numbertext/libnumbertext"
SRC_URI="https://github.com/Numbertext/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

src_configure() {
	econf \
		--disable-static \
		--disable-werror
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}

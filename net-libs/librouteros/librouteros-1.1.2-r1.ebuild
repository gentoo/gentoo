# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for accessing MikroTik's RouterOS via its API"
HOMEPAGE="https://verplant.org/librouteros/"
SRC_URI="https://verplant.org/librouteros/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="debug"

RDEPEND="dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e 's/-Werror//g' -i src/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}

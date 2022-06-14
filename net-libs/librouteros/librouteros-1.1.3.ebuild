# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for accessing MikroTik's RouterOS via its API"
HOMEPAGE="https://octo.github.io/librouteros/"
SRC_URI="https://github.com/octo/${PN}/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e 's/-Werror//g' -i src/Makefile.am || die
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}

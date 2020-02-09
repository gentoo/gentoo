# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for accessing MikroTik's RouterOS via its API"
HOMEPAGE="http://verplant.org/librouteros/"
SRC_URI="http://verplant.org/librouteros/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-remove-Werror.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}

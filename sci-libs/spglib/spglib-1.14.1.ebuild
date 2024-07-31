# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Spglib is a C library for finding and handling crystal symmetries"
HOMEPAGE="https://atztogo.github.io/spglib/"
SRC_URI="https://github.com/atztogo/spglib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}

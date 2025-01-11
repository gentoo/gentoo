# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SigScheme is an R5RS Scheme interpreter for embedded use"
HOMEPAGE="https://github.com/uim/sigscheme"
SRC_URI="https://github.com/uim/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

inherit autotools flag-o-matic

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-autoconf.patch
)

src_prepare() {
	default
	eautoconf # 879679
}

src_configure() {
	use elibc_musl && append-cflags -D_GNU_SOURCE # 906864
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

D0BLIND_HASH="c32ee93edd10288ca40e1eb81263f0a37309b32c" # xonotic-0.8.5

DESCRIPTION="Blind-ID library for user identification using RSA blind signatures"
HOMEPAGE="https://gitlab.com/xonotic/d0_blind_id/"
SRC_URI="https://gitlab.com/xonotic/d0_blind_id/-/archive/${D0BLIND_HASH}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${D0BLIND_HASH}"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="dev-libs/gmp:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		--enable-rijndael
		--without-openssl
		--without-tfm
		--without-tommath
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	dodoc d0_blind_id.txt

	find "${ED}" -type f -name "*.la" -delete || die
}

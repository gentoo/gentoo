# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Attest the trustworthiness of a device against a human using time-based OTP"
HOMEPAGE="https://github.com/tpm2-software/tpm2-totp"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-crypt/tpm2-tss-2.0:=
	media-gfx/qrencode:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-defaultflags
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

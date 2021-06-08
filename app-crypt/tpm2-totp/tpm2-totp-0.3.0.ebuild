# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Attest the trustworthiness of a device against a human using time-based OTP"
HOMEPAGE="https://github.com/tpm2-software/tpm2-totp"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="plymouth test"

REQUIRED_USE="test? ( plymouth )"

RDEPEND="app-crypt/tpm2-tss
	media-gfx/qrencode
	plymouth? ( sys-boot/plymouth )"
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm
		app-crypt/tpm2-tools
		>=app-crypt/tpm2-tss-3.0.0
		sys-apps/fakeroot
		sys-auth/oath-toolkit
	)"

BDEPEND="virtual/pkgconfig"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-Remove-bogus-value-from-Makefile.am"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-defaultflags \
		$(use_enable plymouth) \
		$(use_enable test integration)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="OpenSSL Engine for TPM2 devices"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=app-crypt/tpm2-tss-2.2.2:=
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-build-add-disable-defaultflags.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable test unit) \
		--disable-defaultflags \
		--disable-static
}

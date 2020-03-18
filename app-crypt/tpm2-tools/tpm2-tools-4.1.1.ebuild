# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for the TPM 2.0 TSS"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl test"
RESTRICT="!test? ( test )"

RDEPEND=">=app-crypt/tpm2-tss-2.3.1:=
	net-misc/curl:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-libressl.patch"
)

src_configure() {
	econf \
		$(use_enable !libressl hardening) \
		$(use_enable test unit)
}

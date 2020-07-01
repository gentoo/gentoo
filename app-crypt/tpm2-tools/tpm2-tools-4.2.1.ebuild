# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for the TPM 2.0 TSS"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+fapi libressl"

# Integration test are now run as part of the testing suite, which will fail
# because none of the supported TPM emulators are in Portage. In a future
# version of tpm2-tools, swtpm will be supported and the tests can be run.
RESTRICT="test"

RDEPEND="net-misc/curl:=
	fapi? ( >=app-crypt/tpm2-tss-2.4.0:=[fapi?] )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}/${P}-libressl.patch"
)

src_configure() {
	econf \
		$(use_enable fapi) \
		$(use_enable !libressl hardening)
}

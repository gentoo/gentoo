# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="OpenSSL Provider for TPM2 integration"
HOMEPAGE="https://github.com/tpm2-software/tpm2-openssl"
SRC_URI="https://github.com/tpm2-software/tpm2-openssl/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/tpm2-tss-3.2.0:=
	>=dev-libs/openssl-3:="
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm[gnutls(+)]
		app-crypt/tpm2-abrmd
		app-crypt/tpm2-tools
	)"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-tests-run-with-simulator-in-container.patch"
	"${FILESDIR}/${PN}-1.2.0-Makefile-add-run-with-simulator-to-extra-dists.patch"
	"${FILESDIR}/${PN}-1.1.1-build-Fix-undefined-references-when-using-slibtool.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_test() {
	"${S}/test/run-with-simulator" swtpm skip-build || die
}

src_install() {
	default
	find "${ED}" -iname '*.la' -delete || die
}

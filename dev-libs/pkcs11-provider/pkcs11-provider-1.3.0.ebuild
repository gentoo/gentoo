# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="OpenSSL 3+ provider to access hardware or software tokens via PKCS#11"
HOMEPAGE="https://github.com/openssl-projects/pkcs11-provider"
SRC_URI="https://github.com/openssl-projects/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# p11-kit provides the default PKCS#11 module (p11-kit-proxy.so)
RDEPEND="
	app-crypt/p11-kit
	>=dev-libs/openssl-3.0.7:=
"
DEPEND="${RDEPEND}
	test? ( dev-libs/nss )
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-libs/nss[utils]
		dev-libs/opensc
		dev-libs/softhsm
		dev-tcltk/expect
		dev-util/xxd
	)
"

src_test() {
	# kryoptic is not packaged
	#
	# softhsm links against OpenSSL and hashes the PIN in C_Login. If
	# the pkcs11 provider is loaded before the default provider, that
	# digest is routed back through the provider into softhsm, which
	# deadlocks on its own mutex. The test suite avoids this through
	# its own config, but the kernel's sign-file and extract-cert load
	# pkcs11 first and hang with softhsm keys unless the provider is
	# configured with "pkcs11-module-block-operations = digest".
	# https://github.com/softhsm/SoftHSMv2/issues/834
	meson_src_test --suite softhsm --suite softokn
}

# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Components used to interact with the YubiHSM 2"
HOMEPAGE="https://developers.yubico.com/yubihsm-shell/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/openssl:=
	net-misc/curl
	dev-libs/libedit
	sys-apps/pcsc-lite
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.0-pcsc-lite-pkgconfig.patch
	"${FILESDIR}"/${PN}-2.6.0-remove-hardcoded-compiler-opts.patch
	"${FILESDIR}"/${PN}-2.6.0-fix-examples-link.patch
)

src_configure() {
	local mycmakeargs=(
		# Allow users to set this, don't force it.
		-DDISABLE_LTO=ON
	)

	cmake_src_configure
}

src_test() {
	# TODO: hook up more tests. Requires unpackaged dependencies and hosting a connector.
	# See https://github.com/Yubico/yubihsm-shell/issues/381 and the github workflow.
	local CMAKE_SKIP_TESTS=(
		# main: Assertion `yrc == YHR_SUCCESS' failed.
		attest
		generate_ec
		generate_hmac
		import_authkey
		import_rsa
		info
		wrap
		wrap_data
		yubico_otp
		echo
		asym_auth
		import_ec
		generate_rsa
		logs
		ssh
		decrypt_rsa
		decrypt_ec
		import_ed
		change_authkey
		encrypt_aes
		# Unpackaged
		# https://github.com/YubicoLabs/pkcs11test
		# line 42: pkcs11test: command not found
		pkcs11test
		# open_session: Assertion `rv == CKR_OK' failed.
		aes_encrypt_test
		ecdh_derive_test
		ecdh_sp800_test
		rsa_enc_test
		pss_sign_test
		asym_wrap_test
		# Requires unpackaged ghostunnel to host connector locally
		# Failed connecting 'http://localhost:12345': Unable to find a suitable connector
		bash_tests
		wrapped_tests
	)
	cmake_src_test
}

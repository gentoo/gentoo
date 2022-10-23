# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv -sparc x86 ~ppc-macos ~x64-macos"
IUSE="debug doc nss openssl static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( nss openssl )"

RDEPEND="
	openssl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	nss? ( >=dev-libs/nss-3.52[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/libsrtp-2.4.2-doc.patch )

multilib_src_configure() {
	local crypto_lib="none"
	use openssl && crypto_lib="openssl"
	use nss && crypto_lib="nss"

	# stdout: default error output for messages in debug
	# openssl-kdf: OpenSSL 1.1.0+
	local emesonargs=(
		-Dcrypto-library=${crypto_lib}
		-Dcrypto-library-kdf=disabled
		-Dfuzzer=disabled
		-Dlog-stdout=true
		-Dpcap-tests=disabled
		-Ddefault_library=$(usex static-libs both shared)

		$(meson_feature test tests)
		$(meson_native_use_feature doc)
		$(meson_use debug debug-logging)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
	if multilib_is_native_abi && use doc; then
		meson_src_compile doc
	fi
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		dodoc -r html
	fi
	meson_src_install
}

multilib_src_install_all() {
	local DOCS=( CHANGES )
	einstalldocs
}

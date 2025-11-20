# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/leancrypto.asc
inherit dot-a meson-multilib verify-sig

DESCRIPTION="Lean cryptographic library usable for bare-metal environments "
HOMEPAGE="https://leancrypto.org/"
SRC_URI="
	https://leancrypto.org/leancrypto/releases/${P}/${P}.tar.xz
	verify-sig? ( https://leancrypto.org/leancrypto/releases/${P}/${P}.tar.xz.asc )
"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="asm test tools"
RESTRICT="!test? ( test )"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-leancrypto )
"

PATCHES=(
	"${FILESDIR}"/${P}-use-init.patch
	"${FILESDIR}"/${P}-avoid-accel-crash.patch
	"${FILESDIR}"/${PN}-1.6.0-no-force-lto.patch
)

src_configure() {
	lto-guarantee-fat
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		-Dstrip=false
		$(meson_use !asm disable-asm)
		$(meson_feature test tests)
		$(meson_native_use_feature tools apps)
	)

	meson_src_configure
}

multilib_src_test() {
	# Only run the regression tests rather than the performance ones
	meson_src_test --timeout-multiplier=16 --suite=regression
}

multilib_src_install_all() {
	strip-lto-bytecode
	einstalldocs
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Intelligent Storage Acceleration Library - cryptographic components"
HOMEPAGE="https://github.com/intel/isa-l_crypto"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_avx512f"

# AVX512 support in yasm is still work in progress
# Note that dev-libs/isa-l-2.31.1 has a workaround for this, but that
# doesn't seem to have reached isa-l_crypto yet.
BDEPEND="amd64? (
	cpu_flags_x86_avx512f? ( >=dev-lang/nasm-2.13 )
	!cpu_flags_x86_avx512f? ( || (
		>=dev-lang/nasm-2.11.01
		>=dev-lang/yasm-1.2.0
	) )
)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.25.0_makefile-no-D.patch
	"${FILESDIR}"/${PN}-2.25.0-sha1_mb-build.patch
	"${FILESDIR}"/${PN}-2.25.0-tests-use-internal.patch
	"${FILESDIR}"/${PN}-2.25.0-configure-avx512.patch
	"${FILESDIR}"/${PN}-2.25.0-respect-LDFLAGS.patch
	"${FILESDIR}"/${PN}-2.25.0-no-clobber-hardened.patch
)

src_prepare() {
	default

	# isa-l does not support arbitrary assemblers on amd64 (and presumably x86),
	# it must be either nasm or yasm.
	use amd64 && unset AS

	eautoreconf
}

src_configure() {
	# Test failures with LTO (bug #924865)
	# Likely related to https://github.com/intel/isa-l_crypto/issues/73
	append-flags -fno-strict-aliasing

	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jedisct1.asc
inherit autotools multilib-minimal verify-sig

DESCRIPTION="A portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://libsodium.org"
SRC_URI="https://download.libsodium.org/${PN}/releases/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.libsodium.org/${PN}/releases/${P}.tar.gz.sig )"

LICENSE="ISC"
SLOT="0/23"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+asm minimal static-libs +urandom cpu_flags_x86_sse4_1 cpu_flags_x86_aes"

BDEPEND="verify-sig? ( app-crypt/openpgp-keys-jedisct1 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.10-cpuflags.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		$(use_enable minimal)
		$(use_enable !urandom blocking-random)
		$(use_enable static-libs static)
		$(use_enable cpu_flags_x86_sse4_1 sse4_1)
		$(use_enable cpu_flags_x86_aes aesni)
	)

	# --disable-pie is needed on x86, see bug #512734
	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_32" ]] ; then
		myeconfargs+=( --disable-pie )

		# --disable-ssp is needed on musl x86
		# TODO: Check if still needed? bug #747346
		if use elibc_musl ; then
			myeconfargs+=( --disable-ssp )
		fi
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="A portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://libsodium.org"

if [[ ${PV} == *_p* ]] ; then
	MY_P=${PN}-$(ver_cut 1-3)-stable-$(ver_cut 5-)
	MINISIGN_KEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

	# We use _pN to represent 'stable releases'
	# These are backports from upstream to the last release branch
	# See https://download.libsodium.org/libsodium/releases/README.html
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

	# TODO: Could verify-sig.eclass support minisig? bug #783066
	SRC_URI+=" verify-sig? ( https://dev.gentoo.org/~sam/distfiles/dev-libs/libsodium/${MY_P}.tar.gz.minisig -> ${P}.tar.gz.minisig )"

	S="${WORKDIR}"/${PN}-stable
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/jedisct1.asc
	inherit verify-sig

	SRC_URI="https://download.libsodium.org/${PN}/releases/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://download.libsodium.org/${PN}/releases/${P}.tar.gz.sig )"
fi

LICENSE="ISC"
SLOT="0/23"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+asm minimal static-libs +urandom"

CPU_USE=( cpu_flags_x86_{aes,sse4_1} )
IUSE+=" ${CPU_USE[@]}"

if [[ ${PV} == *_p* ]] ; then
	IUSE+=" verify-sig"
	BDEPEND+=" verify-sig? ( app-crypt/minisign )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.10-cpuflags.patch
)

src_unpack() {
	if [[ ${PV} == *_p* ]] ; then
		if use verify-sig ; then
			ebegin "Verifying signature using app-crypt/minisign"
			minisign -V \
				-P ${MINISIGN_KEY} \
				-x "${DISTDIR}"/${P}.tar.gz.minisig \
				-m "${DISTDIR}"/${P}.tar.gz
			eend $? || die "Failed to verify distfile using minisign!"
		fi

		default
	else
		verify-sig_src_unpack
	fi
}

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		$(use_enable cpu_flags_x86_aes aesni)
		$(use_enable cpu_flags_x86_sse4_1 sse4_1)
		$(use_enable minimal)
		$(use_enable static-libs static)
		$(use_enable !urandom blocking-random)
	)

	# --disable-pie is needed on x86, see bug #512734
	# TODO: Check if still needed?
	if [[ ${ABI} == x86 ]] ; then
		myeconfargs+=( --disable-pie )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

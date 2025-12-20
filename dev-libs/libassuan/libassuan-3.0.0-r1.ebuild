# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should:
# 1. Join the "Gentoo" project at https://dev.gnupg.org/project/view/27/
# 2. Subscribe to release tasks like https://dev.gnupg.org/T6159
# (find the one for the current release then subscribe to it +
# any subsequent ones linked within so you're covered for a while.)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit verify-sig libtool

DESCRIPTION="IPC library used by GnuPG and GPGME"
HOMEPAGE="https://www.gnupg.org/related_software/libassuan/index.en.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND=">=dev-libs/libgpg-error-1.33"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gnupg )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-fix-typo.patch
)

src_prepare() {
	default
	# for Solaris shared libraries
	elibtoolize
}

src_configure() {
	local myeconfargs=(
		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# ppl need to use libassuan-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}

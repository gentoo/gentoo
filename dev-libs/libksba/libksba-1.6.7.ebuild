# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should:
# 1. Join the "Gentoo" project at https://dev.gnupg.org/project/view/27/
# 2. Subscribe to release tasks like https://dev.gnupg.org/T6159
# (find the one for the current release then subscribe to it +
# any subsequent ones linked within so you're covered for a while.)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
# in-source builds are not supported: https://dev.gnupg.org/T6313#166339
inherit toolchain-funcs out-of-source verify-sig libtool

DESCRIPTION="X.509 and CMS (PKCS#7) library"
HOMEPAGE="https://www.gnupg.org/related_software/libksba"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="LGPL-3+ GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.33"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-no-fgrep-ksba-config.patch
)

src_prepare() {
	default

	elibtoolize  # necessary on Solaris for shared lib support
}

my_src_configure() {
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"

	local myeconfargs=(
		--disable-valgrind-tests
		$(use_enable static-libs static)

		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
		LIBGCRYPT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-libgcrypt-config"
	)

	econf "${myeconfargs[@]}"
}

my_src_install() {
	default

	# People need to use ksba-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}

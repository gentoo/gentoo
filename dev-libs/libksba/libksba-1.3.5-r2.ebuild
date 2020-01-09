# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="X.509 and CMS (PKCS#7) library"
HOMEPAGE="http://www.gnupg.org/related_software/libksba"
SRC_URI="mirror://gnupg/libksba/${P}.tar.bz2"

LICENSE="LGPL-3+ GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.8"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		GPG_ERROR_CONFIG="${EROOT}/usr/bin/${CHOST}-gpg-error-config"
		LIBGCRYPT_CONFIG="${EROOT}/usr/bin/${CHOST}-libgcrypt-config"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# ppl need to use lib*-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Public-domain version of lzip compressor"
HOMEPAGE="https://www.nongnu.org/lzip/pdlzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/pdlzip/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P/_/-}.tar.gz.sig )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )"

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		CPPFLAGS="${CPPFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}

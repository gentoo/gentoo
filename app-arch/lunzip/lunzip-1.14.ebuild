# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Decompressor for the lzip format, written in C"
HOMEPAGE="https://www.nongnu.org/lzip/lunzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/lunzip/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P/_/-}.tar.gz.sig )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )"

src_configure() {
	# not autotools-based
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CC="$(tc-getCC)"
		CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	./configure "${myconf[@]}" || die
}

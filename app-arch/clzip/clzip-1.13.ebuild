# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="C language version of lzip"
HOMEPAGE="https://www.nongnu.org/lzip/clzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/clzip/${P/_/-}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P/_/-}.tar.gz.sig )"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

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

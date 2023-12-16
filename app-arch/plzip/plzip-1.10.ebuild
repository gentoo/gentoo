# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Parallel lzip compressor"
HOMEPAGE="https://www.nongnu.org/lzip/plzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.gz.sig )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv x86"

RDEPEND="app-arch/lzlib:0="
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )"

src_configure() {
	local myconf=(
		--prefix="${EPREFIX}"/usr
		CXX="$(tc-getCXX)"
		CPPFLAGS="${CPPFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}

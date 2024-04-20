# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Lossless data compressor based on the LZMA algorithm"
HOMEPAGE="https://www.nongnu.org/lzip/lzip.html"
SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${P/_/-}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/${PN}/${P/_/-}.tar.gz.sig )"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}

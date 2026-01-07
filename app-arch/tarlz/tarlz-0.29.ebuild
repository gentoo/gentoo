# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs unpacker verify-sig

DESCRIPTION="A parallel archiver combining tar and lzip"
HOMEPAGE="https://www.nongnu.org/lzip/tarlz.html"
SRC_URI="
	https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.lz
	verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.lz.sig )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-arch/lzlib-1.12
"
DEPEND="
	${RDEPEND}
	test? ( app-alternatives/lzip )
"
BDEPEND="
	$(unpacker_src_uri_depends)
	verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )
"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.lz{,.sig}
	unpacker "${DISTDIR}"/${P}.tar.lz
}

src_configure() {
	econf \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

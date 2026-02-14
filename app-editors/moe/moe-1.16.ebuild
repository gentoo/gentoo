# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs unpacker verify-sig

DESCRIPTION="Powerful and user-friendly console text editor"
HOMEPAGE="https://www.gnu.org/software/moe/"
SRC_URI="
	mirror://gnu/${PN}/${P}.tar.lz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.lz.sig )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	virtual/pkgconfig
	verify-sig? ( >=sec-keys/openpgp-keys-antoniodiazdiaz-20260213 )
"

PATCHES=( "${FILESDIR}"/${PN}-respect-user-flags.patch )

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.lz{,.sig}
	unpacker "${DISTDIR}"/${P}.tar.lz
}

src_configure() {
	tc-export CXX PKG_CONFIG
	default
}

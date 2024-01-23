# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/cathugger.gpg
inherit verify-sig

DESCRIPTION="Vanity address generator for v3 Tor hidden service addresses"
HOMEPAGE="https://github.com/cathugger/mkp224o"
SRC_URI="
	https://github.com/cathugger/${PN}/releases/download/v${PV}/${PN}-${PV}-src.tar.gz
	verify-sig? ( https://github.com/cathugger/${PN}/releases/download/v${PV}/${PN}-${PV}-src.tar.gz.sig )
"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse2 pcre"

DEPEND="
	dev-libs/libsodium:=
	pcre? ( dev-libs/libpcre2:= )
"
RDEPEND="${DEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-cathugger )"

DOCS=( OPTIMISATION.txt README.md )

src_configure() {
	local myeconfargs=(
		--enable-regex=$(usex pcre)
		--enable-statistics
	)
	use cpu_flags_x86_sse2 && myeconfargs+=( --enable-donna-sse2 )

	econf "${myeconfargs[@]}"
}

src_install() {
	einstalldocs
	dobin ${PN}
}

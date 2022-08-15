# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Vanity address generator for v3 Tor hidden service addresses"
HOMEPAGE="https://github.com/cathugger/mkp224o"
SRC_URI="https://github.com/cathugger/${PN}/releases/download/v${PV}/${PN}-${PV}-src.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="cpu_flags_x86_sse2 pcre2"

DEPEND="
	dev-libs/libsodium:=
	pcre2? ( dev-libs/libpcre2:= )
"
RDEPEND="${DEPEND}"

DOCS=( OPTIMISATION.txt README.md )

src_configure() {
	local myeconfargs=(
		--enable-regex=$(usex pcre2)
		--enable-statistics
	)
	use cpu_flags_x86_sse2 && myeconfargs+=( --enable-donna-sse2 )

	econf "${myeconfargs[@]}"
}

src_install() {
	einstalldocs
	dobin ${PN}
}

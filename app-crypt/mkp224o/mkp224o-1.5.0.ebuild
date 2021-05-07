# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Vanity address generator for v3 Tor hidden service addresses"
HOMEPAGE="https://github.com/cathugger/mkp224o"
SRC_URI="https://github.com/cathugger/mkp224o/releases/download/v1.5.0/mkp224o-${PV}-src.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amd64-51-30k amd64-64-24k besort binsearch +donna donna-sse2 pcre2 ref10 +statistics"
REQUIRED_USE="
	^^ ( amd64-51-30k amd64-64-24k donna donna-sse2 ref10 )
	besort? ( binsearch )
"

DEPEND="
	dev-libs/libsodium
	pcre2? ( dev-libs/libpcre2 )
"
RDEPEND="${DEPEND}"

DOCS=( OPTIMISATION.txt README.txt )

my_use_enable() {
	use "${1}" && echo "--enable-${1}"
}

src_configure() {
	# Passing arguments like --enable-ref10 --disable-donna breaks the
	# configure script.  Instead, only one ed25519 implementation should
	# be --enable'd and the others left unspecified.

	local myeconfargs=(
		$(my_use_enable amd64-51-30k)
		$(my_use_enable amd64-64-24k)
		$(my_use_enable donna)
		$(my_use_enable donna-sse2)
		$(my_use_enable ref10)
		$(use_enable besort)
		$(use_enable binsearch)
		$(use_enable pcre2 regex)
		$(use_enable statistics)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	dobin "${PN}"
	einstalldocs
}

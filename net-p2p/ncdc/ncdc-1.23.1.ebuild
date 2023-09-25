# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs verify-sig

DESCRIPTION="Lightweight direct connect client with a friendly ncurses interface"
HOMEPAGE="https://dev.yorhel.nl/ncdc"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	verify-sig? ( https://dev.yorhel.nl/download/${P}.tar.gz.asc )
"
KEYWORDS="amd64 ~ppc ~sparc x86"

LICENSE="MIT"
SLOT="0"
IUSE="geoip"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	>=dev-libs/glib-2.74:2
	>=net-libs/gnutls-3:=
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/zlib
	geoip? ( dev-libs/libmaxminddb:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/makeheaders
	virtual/pkgconfig
	dev-lang/perl
	verify-sig? ( sec-keys/openpgp-keys-yorhel )
"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/yoranheling.asc

src_configure() {
	local myeconfargs=(
		$(use_with geoip)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

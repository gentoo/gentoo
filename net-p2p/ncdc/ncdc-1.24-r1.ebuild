# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs verify-sig

DESCRIPTION="Lightweight direct connect client with a friendly ncurses interface"
HOMEPAGE="https://dev.yorhel.nl/ncdc"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	verify-sig? ( https://dev.yorhel.nl/download/${P}.tar.gz.asc )
"
LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ~ppc ~sparc ~x86"

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
	dev-lang/perl
	dev-util/makeheaders
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-yorhel )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/yoranheling.asc

PATCHES=(
	"${FILESDIR}/ncdc-1.24-fix-clang16-c99-errors.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_with geoip)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

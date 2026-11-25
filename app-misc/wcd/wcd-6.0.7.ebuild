# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/erwinwaterlander.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Wherever Change Directory"
HOMEPAGE="https://waterlan.home.xs4all.nl/wcd.html"
SRC_URI="
	"https://downloads.sourceforge.net/wcd/${P}.tar.gz"
	verify-sig? ( https://downloads.sourceforge.net/wcd/${P}.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls unicode"

RDEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	unicode? ( dev-libs/libunistring:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/ghostscript-gpl
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-erwinwaterlander )
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.4-gentoo.patch
	"${FILESDIR}"/${PN}-6.0.3-doc-path.patch
)

src_prepare() {
	default
	tc-export CC PKG_CONFIG
}

src_compile() {
	cd src || die
	local myemakeargs=( LFS=1 )
	use nls || myemakeargs+=( ENABLE_NLS= )
	use unicode || myemakeargs+=( UCS= UNINORM= )
	emake ${myemakeargs[@]}
}

src_install() {
	cd src || die
	local DOCS=( ../README.txt )
	default
	emake DESTDIR="${ED}" DOTWCD=1 install-profile sysconfdir="/etc"
}

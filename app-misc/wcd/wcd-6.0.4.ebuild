# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Wherever Change Directory"
HOMEPAGE="http://waterlan.home.xs4all.nl/#WCD_ANCHOR"
SRC_URI="http://waterlan.home.xs4all.nl/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="nls unicode"

RDEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	unicode? ( dev-libs/libunistring:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/ghostscript-gpl
	virtual/pkgconfig
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
	local mycompile="LFS=1"
	use nls || mycompile+=" ENABLE_NLS="
	use unicode && mycompile+=" UCS=1 UNINORM=1"
	emake ${mycompile}
}

src_install() {
	cd src || die
	local DOCS=( ../README.txt )
	default
	emake DESTDIR="${ED}" DOTWCD=1 install-profile sysconfdir="/etc"
}

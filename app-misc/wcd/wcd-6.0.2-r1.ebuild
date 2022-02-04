# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Wherever Change Directory"
HOMEPAGE="http://waterlan.home.xs4all.nl/#WCD_ANCHOR"
SRC_URI="http://waterlan.home.xs4all.nl/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE="nls unicode"

CDEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	unicode? ( dev-libs/libunistring:= )"
DEPEND="${CDEPEND}
	app-text/ghostscript-gpl
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	eapply -p2 "${FILESDIR}"/${PN}-6.0.2-gentoo.patch
	eapply_user
	tc-export CC PKG_CONFIG
}

src_compile() {
	local mycompile="LFS=1"
	use nls || mycompile+=" ENABLE_NLS="
	use unicode && mycompile+=" UCS=1 UNINORM=1"
	emake ${mycompile}
}

src_install() {
	local DOCS=( ../README.txt )
	default
	emake DESTDIR="${D}" DOTWCD=1 install-profile sysconfdir="/etc"
}

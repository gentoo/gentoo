# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="A SKK-like Japanese input method for console"
HOMEPAGE="http://aitoweb.world.coocan.jp/soft.html"
SRC_URI="http://aitoweb.world.coocan.jp/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/sed
	sys-libs/ncurses:=
	virtual/awk
	virtual/pkgconfig"
RDEPEND="sys-libs/ncurses:=
	app-i18n/skk-jisyo"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-system-dic.patch
	"${FILESDIR}"/${PN}-annotation.patch
)
DOCS=( README HISTORY TODO )

src_prepare() {
	sed -i "/SYSTEM_DIC_NAME/a#define SYSTEM_DIC_NAME \"${EPREFIX}/usr/share/skk/SKK-JISYO.L\"" config.h

	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		OPTIMIZE="${CFLAGS}" \
		EXTRALIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin skkfep escmode
	doman skkfep.1
	einstalldocs
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A SKK-like Japanese input method for console"
HOMEPAGE="http://aitoweb.world.coocan.jp/soft.html"
SRC_URI="http://aitoweb.world.coocan.jp/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
BDEPEND="
	app-alternatives/awk
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-system-dic.patch
	"${FILESDIR}"/${PN}-annotation.patch
)

DOCS=( README HISTORY TODO )

src_prepare() {
	sed -i "/SYSTEM_DIC_NAME/a#define SYSTEM_DIC_NAME \"${EPREFIX}/usr/share/skk/SKK-JISYO.L\"" config.h

	default
	# written in K&R C
	append-flags \
		-Wno-implicit-function-declaration \
		-Wno-implicit-int \
		-Wno-return-type
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		OPTIMIZE="${CFLAGS}" \
		EXTRALIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin ${PN} escmode
	doman ${PN}.1
	einstalldocs
}

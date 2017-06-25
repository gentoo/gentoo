# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A SKK-like Japanese input method for console"
HOMEPAGE="http://aitoweb.world.coocan.jp/soft.html"
SRC_URI="http://aitoweb.world.coocan.jp/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/awk"
RDEPEND="${RDEPEND}
	app-i18n/skk-jisyo"

src_prepare() {
	sed -i "/SYSTEM_DIC_NAME/a#define SYSTEM_DIC_NAME \"${EPREFIX}/usr/share/skk/SKK-JISYO.L\"" config.h

	epatch "${FILESDIR}"/${PN}-gentoo.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}"
}

src_install() {
	dobin skkfep escmode
	doman skkfep.1
	dodoc README HISTORY TODO
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skkfep/skkfep-0.87-r1.ebuild,v 1.7 2013/02/12 08:43:53 naota Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A SKK-like Japanese input method for console"
HOMEPAGE="http://homepage2.nifty.com/aito/soft.html"
SRC_URI="http://homepage2.nifty.com/aito/skkfep/${P}.tar.gz"

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
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-LDFLAGS.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}"
}

src_install() {
	dobin skkfep escmode
	doman skkfep.1
	dodoc README HISTORY TODO
}

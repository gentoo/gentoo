# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/lv/lv-4.51-r3.ebuild,v 1.11 2013/09/07 19:53:25 slyfox Exp $

EAPI="4"

inherit autotools eutils toolchain-funcs

MY_P="${PN}${PV//./}"

DESCRIPTION="Powerful Multilingual File Viewer"
HOMEPAGE="http://www.ff.iij4u.or.jp/~nrt/lv/"
SRC_URI="http://www.ff.iij4u.or.jp/~nrt/freeware/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="sys-libs/ncurses
	!app-editors/levee"
DEPEND="${RDEPEND}
	dev-lang/perl"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-xz.diff
	epatch "${FILESDIR}"/${P}-tinfo.patch
	cd "${S}"/src; eautoreconf
}

src_configure() {
	ECONF_SOURCE=src econf
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README hello.sample
	dohtml index.html relnote.html hello.sample.gif
}

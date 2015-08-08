# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Console version of Stardict program"
HOMEPAGE="http://sdcv.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls test"

RDEPEND="sys-libs/zlib
	sys-libs/readline
	>=dev-libs/glib-2.6.1"
DEPEND="${RDEPEND}
	test? ( app-dicts/stardict-quick-ru-en )
	nls? ( >=sys-devel/gettext-0.14.1 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-missing-headers.patch"
	epatch "${FILESDIR}/${P}-crash.patch"
	epatch "${FILESDIR}/${P}-g-handling.patch"
	epatch "${FILESDIR}/${P}-respect-HOME.patch"
	epatch "${FILESDIR}"/${P}-dash.patch
}

src_compile() {
	econf $(use_enable nls)
	emake || die "emake failed"
}

src_test() {
	export HOME=${T}
	mkdir -p "${HOME}/.stardict/dic"
	emake check || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}

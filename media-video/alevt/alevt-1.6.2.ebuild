# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/alevt/alevt-1.6.2.ebuild,v 1.4 2011/10/04 21:34:32 phajdan.jr Exp $

EAPI=4
inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Teletext viewer for X11"
HOMEPAGE="http://www.goron.de/~froese/"
SRC_URI="http://www.goron.de/~froese/alevt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	>=media-libs/libpng-1.4"
DEPEND="${RDEPEND}
	x11-proto/xproto"

RESTRICT="strip"

src_prepare() {
	cp -va Makefile{,.orig}

	epatch \
		"${FILESDIR}"/${P}-respectflags.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_compile() {
	append-flags -fno-strict-aliasing
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin alevt alevt-cap alevt-date
	doman alevt.1x alevt-date.1 alevt-cap.1
	dodoc CHANGELOG README

	insinto /usr/share/icons/hicolor/16x16/apps
	newins contrib/mini-alevt.xpm alevt.xpm
	insinto /usr/share/icons/hicolor/48x48/apps
	newins contrib/icon48x48.xpm alevt.xpm

	make_desktop_entry alevt "AleVT" alevt
}

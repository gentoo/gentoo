# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkbd/xkbd-0.8.15-r1.ebuild,v 1.3 2011/12/21 08:25:19 phajdan.jr Exp $

EAPI=2
inherit eutils

DESCRIPTION="Xkbd - onscreen soft keyboard for X11"
HOMEPAGE="http://handhelds.org/"
SRC_URI="ftp://ftp.yzu.edu.tw/mirror/pub2/ftp.handhelds.org/distributions/familiar/source/v0.8.4-rc1/sources/${P}-CVS.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="doc debug"

RDEPEND="x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXtst
	x11-libs/libXpm
	media-libs/freetype
	dev-libs/expat
	sys-libs/zlib
	doc? ( app-text/docbook-sgml-utils )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	# 2008-03-23 gi1242: Fix handling of -geometry argument
	epatch "${FILESDIR}"/${P}-fix-geometry.patch
	# 2008-03-23 gi1242: Increase default repeat delay
	epatch "${FILESDIR}"/${P}-increase-delay.patch
	epatch "${FILESDIR}"/${P}-fix-keysyms-search.patch
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_compile() {
	emake || die
	use doc && docbook2html README
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README

	if use doc; then
		insinto /usr/share/doc/${PF}/html
		doins *.html
	fi
}

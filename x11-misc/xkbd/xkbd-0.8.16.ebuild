# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkbd/xkbd-0.8.16.ebuild,v 1.1 2012/06/04 22:01:44 xmw Exp $

EAPI=4
inherit eutils

DESCRIPTION="onscreen soft keyboard for X11"
HOMEPAGE="http://trac.hackable1.org/trac/wiki/Xkbd"
SRC_URI="http://trac.hackable1.org/trac/raw-attachment/wiki/Xkbd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
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
	epatch "${FILESDIR}"/${PN}-0.8.15-increase-delay.patch
	epatch "${FILESDIR}"/${PN}-0.8.15-fix-keysyms-search.patch
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_compile() {
	default

	use doc && docbook2html README
}

src_install() {
	default

	if use doc; then
		insinto /usr/share/doc/${PF}/html
		doins *.html
	fi
}

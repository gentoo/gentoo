# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="EWMH (NetWM) compatible pager. Works with Openbox and other EWMH
compliant window managers"
HOMEPAGE="http://sourceforge.net/projects/sf-xpaint/files/netwmpager/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXft
	x11-libs/libXdmcp
	x11-libs/libXau
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
"

src_configure() {
	# econf doesn't work
	tc-export CC
	./configure --prefix=/usr || die

}

src_install() {
	default
	dodoc Changelog
}

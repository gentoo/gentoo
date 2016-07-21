# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A simple tool to retrieve the X screensaver state"
HOMEPAGE="http://tools.suckless.org/x/xssstate"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	x11-proto/scrnsaverproto
	x11-proto/xproto
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.20130103-gentoo.patch
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX='/usr' install
	dodoc README xsidle.sh
	doman ${PN}.1
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/lilyterm/lilyterm-0.9.9.4.ebuild,v 1.2 2013/07/23 15:11:39 jer Exp $

EAPI=5

DESCRIPTION="a terminal emulator based off of libvte that aims to be fast and lightweight"
HOMEPAGE="http://lilyterm.luna.com.tw"
LICENSE="GPL-3"
SRC_URI="http://${PN}.luna.com.tw/file/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/vte:0
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	./autogen.sh
}

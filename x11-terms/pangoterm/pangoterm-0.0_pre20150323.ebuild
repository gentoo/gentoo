# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/pangoterm/pangoterm-0.0_pre20150323.ebuild,v 1.1 2015/03/24 07:51:19 tranquility Exp $

EAPI=5

DESCRIPTION="A GTK/Pango-based terminal that uses libvterm to provide terminal emulation"
HOMEPAGE="http://www.leonerd.org.uk/code/pangoterm/"
SRC_URI="http://dev.gentoo.org/~tranquility/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="=dev-libs/libvterm-neovim-0.0_pre20150309"
RDEPEND="${DEPEND}
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
"

S=${WORKDIR}/pangoterm-0

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
}

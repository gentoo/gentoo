# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ktsuss/ktsuss-2.ebuild,v 1.7 2012/12/10 18:04:23 ago Exp $

EAPI=4

DESCRIPTION="Graphical version of su written in C and GTK+ 2"
HOMEPAGE="http://code.google.com/p/ktsuss/"
SRC_URI="http://ktsuss.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12.11:2
	>=dev-libs/glib-2.16.5:2"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc Changelog CREDITS README
}

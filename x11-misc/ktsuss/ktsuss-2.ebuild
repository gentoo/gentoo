# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Graphical version of su written in C and GTK+ 2"
HOMEPAGE="https://github.com/nomius/ktsuss"
SRC_URI="https://ktsuss.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12.11:2
	>=dev-libs/glib-2.16.5:2"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc Changelog CREDITS README
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="MBrowse is a graphical MIB browser"
HOMEPAGE="https://sourceforge.net/projects/mbrowse/"
SRC_URI="mirror://sourceforge/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	dev-libs/glib
	net-analyzer/net-snmp
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README ChangeLog )

src_prepare() {
	sed -i \
		-e '/LDFLAGS=/d' \
		acinclude.m4 || die
	eautoreconf
}

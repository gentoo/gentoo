# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/conspy/conspy-1.8.ebuild,v 1.3 2012/02/16 18:06:37 phajdan.jr Exp $

EAPI=4
inherit autotools

DESCRIPTION="Remote control for virtual consoles"
HOMEPAGE="http://ace-host.stuart.id.au/russell/files/conspy"
SRC_URI="http://ace-host.stuart.id.au/russell/files/${PN}/${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	dohtml ${PN}.html
}

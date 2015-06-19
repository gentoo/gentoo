# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gtk-gamess/gtk-gamess-2.00.ebuild,v 1.10 2015/01/17 20:14:03 mrueg Exp $

EAPI=5

DESCRIPTION="GUI for GAMESS, a General Atomic and Molecular Electronic Structure System"
HOMEPAGE="http://sourceforge.net/projects/gtk-gamess/"

SRC_URI="mirror://sourceforge/gtk-gamess/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND="
	gnome-base/libglade:2.0
	x11-libs/gtk+:2
	dev-libs/libxml2:2
	sci-chemistry/gamess"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
}

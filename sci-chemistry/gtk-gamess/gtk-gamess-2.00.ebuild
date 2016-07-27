# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="GUI for GAMESS, a General Atomic and Molecular Electronic Structure System"
HOMEPAGE="https://sourceforge.net/projects/gtk-gamess/"

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

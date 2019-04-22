# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="An ncurses based console frontend for cdrtools and dvd+rw-tools"
HOMEPAGE="http://cdw.sourceforge.net"
SRC_URI="mirror://sourceforge/cdw/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	app-cdr/dvd+rw-tools
	dev-libs/libburn
	dev-libs/libcdio:=[-minimal]
	sys-libs/ncurses:0=[unicode]
	virtual/cdrtools
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README THANKS cdw.conf )

src_configure() {
	econf LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

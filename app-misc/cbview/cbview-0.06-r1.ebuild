# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="viewer/converter for CBR/CBZ comic book archives"
HOMEPAGE="http://elvine.org/code/cbview/"
SRC_URI="http://elvine.org/code/cbview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Gtk2
	dev-perl/String-ShellQuote
	app-arch/unrar
	app-arch/unzip"

src_install() {
	dobin cbview
	dodoc README TODO
}

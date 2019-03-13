# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 '')"
S=${WORKDIR}/${MY_P}

DESCRIPTION="TV RSS is a tool for automating torrent downloads"
HOMEPAGE="http://tvtrss.sourceforge.net/"
SRC_URI="mirror://sourceforge/tvtrss/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2
	>=dev-lang/perl-5.8.6
	dev-perl/XML-RAI
	dev-perl/glib-perl
	dev-perl/Gtk2"

src_install() {
	dobin tvrss
}

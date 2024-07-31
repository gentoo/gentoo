# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 '')"

DESCRIPTION="TV RSS is a tool for automating torrent downloads"
HOMEPAGE="http://tvtrss.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/tvtrss/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/gtk+:2
	>=dev-lang/perl-5.8.6
	dev-perl/XML-RAI
	dev-perl/glib-perl
	dev-perl/Gtk2"

src_install() {
	dobin tvrss
}

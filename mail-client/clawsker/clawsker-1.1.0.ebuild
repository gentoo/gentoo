# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Applet to edit Claws Mail's hidden preferences"
HOMEPAGE="http://www.claws-mail.org/clawsker.php"
SRC_URI="http://www.claws-mail.org/tools/${P}.tar.xz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-lang/perl-5.8.0
	>=dev-perl/Gtk2-1.200
	>=dev-perl/Locale-gettext-1.05
	>=mail-client/claws-mail-3.5.0
	"

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
}

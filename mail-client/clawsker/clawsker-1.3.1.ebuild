# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Applet to edit Claws Mail's hidden preferences"
HOMEPAGE="https://www.claws-mail.org/clawsker.php"
SRC_URI="https://www.claws-mail.org/tools/${P}.tar.xz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Gtk3
	dev-perl/Locale-gettext
	dev-perl/File-Which
	mail-client/claws-mail
"

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
}

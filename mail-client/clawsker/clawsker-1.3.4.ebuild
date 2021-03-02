# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Applet to edit Claws Mail's hidden preferences"
HOMEPAGE="https://www.claws-mail.org/clawsker.php"
SRC_URI="https://www.claws-mail.org/tools/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl
	dev-perl/Gtk3
	dev-perl/Locale-gettext
	>=dev-perl/File-Which-1.210
	mail-client/claws-mail
"
DEPEND="test? ( dev-perl/Test-Exception )"

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

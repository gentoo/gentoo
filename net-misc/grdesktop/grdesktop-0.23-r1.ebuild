# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Gtk2 frontend for rdesktop"
HOMEPAGE="http://www.nongnu.org/grdesktop/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	>=gnome-base/libgnomeui-2
	net-misc/rdesktop
	gnome-base/gconf:2
"
DEPEND="${RDEPEND}
	app-text/rarian
	virtual/pkgconfig
"

src_prepare() {
	# Correct icon path. See bug #50295.
	eapply "${FILESDIR}/${P}-desktop.patch"

	# Fix compilation with format-security, bug #517662
	eapply "${FILESDIR}/${P}-format-security.patch"

	sed -e 's/\(GETTEXT_PACKAGE = \)@GETTEXT_PACKAGE@/\1grdesktop/g' \
		-i po/Makefile.in.in || die "sed 2 failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-debug \
		--with-keymap-path=/usr/share/rdesktop/keymaps/
}

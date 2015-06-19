# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pympd/pympd-0.08.1.ebuild,v 1.12 2012/05/05 08:48:22 mgorny Exp $

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit eutils gnome2-utils multilib python toolchain-funcs

DESCRIPTION="a Rhythmbox-like PyGTK+ client for Music Player Daemon"
HOMEPAGE="http://sourceforge.net/projects/pympd"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.6
	|| ( x11-libs/gdk-pixbuf:2[jpeg] x11-libs/gtk+:2[jpeg] )
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e 's:FLAGS =:FLAGS +=:' src/modules/tray/Makefile || die
	sed -i -e 's:\..\/py:/usr/share/pympd/py:g' src/glade/pympd.glade || die
	epatch "${FILESDIR}"/${P}-desktop-entry.patch
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX=/usr DESTDIR="${D}" || die
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install || die
	dodoc README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	python_mod_optimize pympd
	gnome2_icon_cache_update
}

pkg_postrm() {
	python_mod_cleanup pympd
	gnome2_icon_cache_update
}

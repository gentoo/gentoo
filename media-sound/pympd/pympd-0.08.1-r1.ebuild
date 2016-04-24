# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils multilib python-single-r1 toolchain-funcs

DESCRIPTION="a Rhythmbox-like PyGTK+ client for Music Player Daemon"
HOMEPAGE="http://sourceforge.net/projects/pympd"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygtk-2.6:2[${PYTHON_USEDEP}]
	gnome-base/libglade:2.0
	x11-libs/gdk-pixbuf:2[jpeg]
	x11-themes/adwaita-icon-theme
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-desktop-entry.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	python_fix_shebang .
	sed -i -e 's:FLAGS =:FLAGS +=:' src/modules/tray/Makefile || die
	sed -i -e 's:\..\/py:/usr/share/pympd/py:g' src/glade/pympd.glade || die
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX=/usr DESTDIR="${D}"
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

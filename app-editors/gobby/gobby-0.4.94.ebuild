# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gobby/gobby-0.4.94.ebuild,v 1.3 2012/11/21 08:50:09 xarthisius Exp $

EAPI=2

inherit eutils gnome2-utils toolchain-funcs

DESCRIPTION="GTK-based collaborative editor"
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0.5"
KEYWORDS="~amd64 ~x86"
IUSE="avahi doc nls"

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/libsigc++:2
	>=net-libs/libinfinity-0.4[gtk,avahi?]
	x11-libs/gtk+:3
	dev-cpp/libxmlpp:2.6
	x11-libs/gtksourceview:3.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/gnome-doc-utils
		app-text/scrollkeeper
		)
	nls? ( >=sys-devel/gettext-0.12.1 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-missing-icon.patch \
	   "${FILESDIR}"/${P}-gtkmm3.patch
}

src_configure() {
	econf $(use_enable nls) \
		--with-gtk3
}

src_install() {
	emake DESTDIR="${D}" install || die
	domenu contrib/gobby-0.5.desktop
	doicon gobby-0.5.xpm
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

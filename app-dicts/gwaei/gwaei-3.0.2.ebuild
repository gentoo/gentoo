# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit gnome2-utils eutils

DESCRIPTION="Japanese-English Dictionary for GNOME"
HOMEPAGE="http://gwaei.sourceforge.net/"
SRC_URI="mirror://sourceforge/gwaei/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls unique test ncurses"

RDEPEND=">=net-misc/curl-7.21.0
	>=dev-libs/glib-2.25.0:2
	gtk? (
		x11-libs/gtk+:3
		>=app-text/gnome-doc-utils-0.13.0
		unique? ( dev-libs/libunique:3 )
	)
	ncurses? ( sys-libs/ncurses[unicode] )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	test? ( app-text/docbook-xml-dtd:4.1.2 )
	gtk? (
		>=app-text/gnome-doc-utils-0.13.0
		app-text/scrollkeeper
	)
	nls? ( >=sys-devel/gettext-0.17 )
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig"

REQUIRED_USE="unique? ( gtk )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-ncurses.patch
}

src_configure() {
	econf \
		$(use_with gtk gnome) \
		$(use_with ncurses) \
		$(use_with unique libunique) \
		$(use_enable nls) \
		--disable-static \
		--docdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -delete

	dodoc AUTHORS README
}

pkg_preinst() {
	if use gtk ; then
		gnome2_schemas_savelist
	fi
}

pkg_postinst() {
	if use gtk ; then
		gnome2_schemas_update
	fi
}

pkg_postrm() {
	if use gtk ; then
		gnome2_schemas_update
	fi
}

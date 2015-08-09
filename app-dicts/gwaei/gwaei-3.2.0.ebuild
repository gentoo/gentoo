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
IUSE="gtk nls test"

RDEPEND=">=net-misc/curl-7.21.0
	>=dev-libs/glib-2.25.0:2
	gtk? (
		x11-libs/gtk+:3
		>=app-text/gnome-doc-utils-0.13.0
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	test? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/scrollkeeper-dtd
	)
	gtk? (
		>=app-text/gnome-doc-utils-0.13.0
	)
	nls? ( >=sys-devel/gettext-0.17 )
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with gtk gnome) \
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

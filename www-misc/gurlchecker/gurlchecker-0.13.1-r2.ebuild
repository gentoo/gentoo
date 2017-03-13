# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Gnome tool that checks links on web pages/sites"
HOMEPAGE="http://gurlchecker.labs.libre-entreprise.org/"
SRC_URI="http://labs.libre-entreprise.org/frs/download.php/857/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~x86"
SLOT="0"
IUSE="clamav json sqlite ssl tidy"

RDEPEND="
	>=x11-libs/gtk+-2.6:2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2:2.0
	>=dev-libs/libxml2-2.6:2
	>=net-libs/gnet-2
	>=dev-libs/libcroco-0.6
	clamav? ( app-antivirus/clamav )
	json? ( >=dev-libs/json-glib-0.8 )
	sqlite? ( >=dev-db/sqlite-3.6:3 )
	ssl? ( >=net-libs/gnutls-1 )
	tidy? ( app-text/htmltidy )
"
# docbook-sgml-utils used to build the man page
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.30
	app-text/docbook-sgml-utils
	>=dev-util/gtk-doc-am-1.1
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.13.1-gnutls.patch"

	# Stop manipulating LDFLAGS for no reason
	epatch "${FILESDIR}/${PN}-0.13.1-ldflags.patch"

	# Fix tidy.h include dir for Gentoo:
	epatch "${FILESDIR}/${PN}-0.10.5-autoconf-tidy.patch"

	# Fix .desktop validation
	sed -e 's/Application;//' \
		-i gurlchecker.desktop.in || die

	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS CONTRIBUTORS ChangeLog FAQ NEWS README THANKS TODO"

	gnome2_src_configure \
		--with-croco \
		$(use_with clamav) \
		$(use_with json) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl gnutls) \
		$(use_with tidy)
}

src_install() {
	gnome2_src_install

	rm -r "${D}"/usr/share/doc/${PN} || die
}

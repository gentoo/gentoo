# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicate/libindicate-12.10.1-r1.ebuild,v 1.1 2015/04/05 16:09:44 mgorny Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils flag-o-matic vala

DESCRIPTION="A library to raise flags on DBus for other components of the desktop to pick up and visualize"
HOMEPAGE="http://launchpad.net/libindicate"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="gtk +introspection"

RESTRICT="test" # consequence of the -no-mono.patch

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.30
	>=dev-libs/libdbusmenu-0.6.2[introspection?]
	dev-libs/libxml2
	gtk? (
		dev-libs/libdbusmenu[gtk3]
		>=x11-libs/gtk+-3.2:3
	)
	introspection? ( >=dev-libs/gobject-introspection-1 )
	!<${CATEGORY}/${PN}-0.6.1-r201"
EAUTORECONF_DEPEND="dev-util/gtk-doc-am
	gnome-base/gnome-common"
DEPEND="${RDEPEND}
	${EAUTORECONF_DEPEND}
	$(vala_depend)
	app-text/gnome-doc-utils
	virtual/pkgconfig"

src_prepare() {
	vala_src_prepare

	epatch "${FILESDIR}"/${PN}-0.6.1-no-mono.patch

	sed -i -e "s:vapigen:vapigen-$(vala_best_api_version):" configure.ac || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die

	eautoreconf
}

src_configure() {
	append-flags -Wno-error

	# python bindings are only for GTK+-2.x
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-silent-rules \
		--disable-static \
		$(use_enable gtk) \
		$(use_enable introspection) \
		--disable-python \
		--disable-scrollkeeper \
		--with-gtk=3 \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS

	nonfatal dosym /usr/share/doc/${PF}/html/${PN} /usr/share/gtk-doc/html/${PN}

	prune_libtool_files
}

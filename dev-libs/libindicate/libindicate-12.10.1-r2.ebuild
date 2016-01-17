# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils flag-o-matic vala

DESCRIPTION="A library to raise flags on DBus for other components of the desktop to pick up and visualize"
HOMEPAGE="https://launchpad.net/libindicate"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm hppa ~mips ppc ~ppc64 ~sparc ~x86"
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

	sed -i \
		-e "s:vapigen:vapigen-$(vala_best_api_version):" \
		-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" \
		configure.ac || die

	eautoreconf
}

src_configure() {
	append-flags -Wno-error

	# python bindings are only for GTK+-2.x
	econf \
		--disable-silent-rules \
		--disable-static \
		$(use_enable gtk) \
		$(use_enable introspection) \
		--disable-python \
		--disable-scrollkeeper \
		--with-gtk=3
}

src_install() {
	# work around failing parallel installation (-j1)
	# until a better fix is available. (bug #469032)
	emake -j1 DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS

	prune_libtool_files
}

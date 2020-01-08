# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"
inherit autotools flag-o-matic vala xdg-utils

DESCRIPTION="Library to raise flags on DBus for other components of the desktop"
HOMEPAGE="https://launchpad.net/libindicate"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 sparc x86"
IUSE="gtk +introspection"

RESTRICT="test" # consequence of the -no-mono.patch

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libdbusmenu[introspection?]
	dev-libs/libxml2
	gtk? (
		dev-libs/libdbusmenu[gtk3]
		x11-libs/gtk+:3
	)
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/gnome-doc-utils
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.1-no-mono.patch
	"${FILESDIR}"/${PN}-12.10.1-werror.patch
)

src_prepare() {
	default
	xdg_environment_reset
	vala_src_prepare

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
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}

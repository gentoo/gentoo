# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.24"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="telepathy v4l"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-0.9.6:=
	dev-libs/folks[vala(+)]
	gnome-base/gnome-desktop:3=[introspection]
	gnome-extra/evolution-data-server[vala]
	net-libs/telepathy-glib[vala]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=dev-libs/folks-0.11.4:=[eds,telepathy?]
	>=dev-libs/libgee-0.10:0.8
	>=dev-libs/glib-2.44:2
	>=gnome-base/gnome-desktop-3.0:3=
	net-libs/gnome-online-accounts:=[vala]
	>=x11-libs/gtk+-3.22:3
	>=gnome-extra/evolution-data-server-3.13.90:=[gnome-online-accounts]
	v4l? ( >=media-video/cheese-3.5.91:= )
	telepathy? ( >=net-libs/telepathy-glib-0.22 )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxml2
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	# Regenerate the pre-generated C sources, bug #471628
	if ! use v4l; then
		touch src/*.vala
	fi

	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use v4l cheese)
		$(meson_use telepathy)
		-Dmanpage=true
		-Ddocs=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_icon_cache_update
}

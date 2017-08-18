# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.24"

inherit gnome2 vala

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="v4l"
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
# folks-0.11.4 to avoid build issues with vala-0.36, upstream 7a9001b056b4fb1d00375e7b2adeda9b7cf93c90
RDEPEND="
	>=dev-libs/folks-0.11.4:=[eds,telepathy]
	>=dev-libs/glib-2.37.6:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-extra/evolution-data-server-3.13.90:=[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3=
	media-libs/clutter:1.0
	media-libs/clutter-gtk:1.0
	media-libs/libchamplain:0.12
	net-libs/gnome-online-accounts:=
	>=net-libs/telepathy-glib-0.17.5
	>=sci-geosciences/geocode-glib-3.15.3
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.20.0:3
	x11-libs/pango
	v4l? ( >=media-video/cheese-3.5.91:= )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-vala-0.35-part1.patch
	"${FILESDIR}"/${PV}-fix-vala-0.35-part2.patch
)

src_prepare() {
	# Regenerate the pre-generated C sources, bug #471628
	if ! use v4l; then
		touch src/*.vala
	fi

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-man-pages \
		$(use_with v4l cheese)
}

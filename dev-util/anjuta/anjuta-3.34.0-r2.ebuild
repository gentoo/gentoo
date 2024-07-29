# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Base library of defunct IDE for GNOME to run applications"
HOMEPAGE="https://wiki.gnome.org/Apps/Anjuta https://gitlab.gnome.org/Archive/anjuta"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-libs/gdl-3.5.5:3=
	>=dev-libs/glib-2.34:2[dbus]
	>=dev-libs/libxml2-2.4.23
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.10:3
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-minimal.patch
)

src_configure() {
	gnome2_src_configure \
		--disable-debug \
		--disable-introspection \
		--disable-neon \
		--disable-nls \
		--disable-plugin-subversion \
		--disable-serf \
		--disable-static
}

src_compile() {
	emake -C libanjuta/interfaces libanjuta-interfaces.la
	emake -C libanjuta libanjuta-${PV%%.*}.la
}

src_install() {
	emake DESTDIR="${D}" -C libanjuta install-am
	emake DESTDIR="${D}" -C libanjuta/interfaces install-am
	emake DESTDIR="${D}" -C src install-dist_anjuta_pixmapsDATA
	find "${ED}" -type f -name '*.la' -delete || die
}

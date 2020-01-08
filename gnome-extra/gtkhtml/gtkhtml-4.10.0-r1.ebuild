# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="Lightweight HTML rendering/printing/editing engine"
HOMEPAGE="https://gitlab.gnome.org/Archive/gtkhtml"

LICENSE="GPL-2+ LGPL-2+"
SLOT="4.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# orbit is referenced in configure, but is not used anywhere else
RDEPEND="
	>=x11-libs/gtk+-3.2:3
	>=x11-libs/cairo-1.10:=
	x11-libs/pango
	>=app-text/enchant-2.0.0
	gnome-base/gsettings-desktop-schemas
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0:2.4
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	sys-devel/gettext
	dev-util/glib-utils
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

PATCHES=(
	 "${FILESDIR}"/enchant-2.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install

	# Don't collide with 3.14 slot
	mv "${ED}"/usr/bin/gtkhtml-editor-test{,-${SLOT}} || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="introspection"

RDEPEND=">=dev-libs/glib-2.42:=
	>=x11-libs/cairo-1:=
	>=x11-libs/gtk+-2.20:2=
	>=x11-libs/gtk+-3.22:3=[introspection?]
	x11-libs/libX11:=
	x11-libs/libwnck:3=
	>=xfce-base/exo-0.11.2:=
	>=xfce-base/garcon-0.5:=
	>=xfce-base/libxfce4ui-4.13:=
	>=xfce-base/libxfce4util-4.13:=[introspection?]
	>=xfce-base/xfconf-4.13:=
	introspection? ( dev-libs/gobject-introspection:= )"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable introspection)

		# enable GTK+2 compatibility
		--enable-gtk2
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

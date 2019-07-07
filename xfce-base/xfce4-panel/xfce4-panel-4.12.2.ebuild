# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils toolchain-funcs xdg-utils

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.100:=
	>=dev-libs/glib-2.24:=
	>=x11-libs/cairo-1:=
	>=x11-libs/gtk+-2.20:2=
	>=x11-libs/gtk+-3.2:3=
	x11-libs/libX11:=
	>=x11-libs/libwnck-2.31:1=
	>=xfce-base/exo-0.8:=
	>=xfce-base/garcon-0.3:=[gtk2(+)]
	>=xfce-base/libxfce4ui-4.11:=
	>=xfce-base/libxfce4util-4.11:=
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	# Some of the files are missing DBUS_CFLAGS. However, normally they
	# don't fail because older versions of dep libs pull them in. Put
	# them explicitly to work with all dependency versions.
	local -x CPPFLAGS="${CPPFLAGS} $($(tc-getPKG_CONFIG) --cflags dbus-glib-1)"
	local myconf=(
		--enable-gtk3
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

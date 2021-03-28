# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala xdg-utils

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+dbusmenu introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND=">=dev-libs/glib-2.50
	>=x11-libs/cairo-1
	>=x11-libs/gtk+-3.22:3[introspection?]
	x11-libs/libX11
	x11-libs/libwnck:3
	>=xfce-base/exo-0.11.2:=
	>=xfce-base/garcon-0.5:=
	>=xfce-base/libxfce4ui-4.15.8:=
	>=xfce-base/libxfce4util-4.15.6:=[introspection?]
	>=xfce-base/xfconf-4.13:=
	dbusmenu? ( >=dev-libs/libdbusmenu-16.04.0[gtk3] )
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-lang/perl
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# stupid vala.eclass...
	default
}

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable dbusmenu dbusmenu-gtk3)
		$(use_enable vala)
	)

	use vala && vala_src_prepare
	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

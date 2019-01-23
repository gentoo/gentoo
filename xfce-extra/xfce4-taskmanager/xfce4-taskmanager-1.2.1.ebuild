# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Easy to use task manager"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-taskmanager"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+gtk3"

RDEPEND="
	x11-libs/cairo:=
	x11-libs/libX11:=
	x11-libs/libXmu:=
	gtk3? (
		x11-libs/gtk+:3=
		x11-libs/libwnck:3=
	)
	!gtk3? (
		>=x11-libs/gtk+-2.12:2=
		x11-libs/libwnck:1=
	)"
# GTK+2 is required unconditionally
# https://bugzilla.xfce.org/show_bug.cgi?id=11819
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	>=x11-libs/gtk+-2.12:2
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure() {
	local myconf=(
		--enable-wnck
		$(use_enable gtk3)
		--disable-gksu
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

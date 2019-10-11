# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Easy to use task manager"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-taskmanager"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	x11-libs/cairo:=
	x11-libs/libX11:=
	x11-libs/libXmu:=
	x11-libs/gtk+:3=
	x11-libs/libwnck:3="
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		--enable-wnck
		# GTK+3 is required unconditionally anyway
		--disable-gtk2
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

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A weather plug-in for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-weather-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="upower"

RDEPEND=">=dev-libs/glib-2.20:=
	dev-libs/libxml2:=
	>=net-libs/libsoup-2.32:=[ssl]
	>=x11-libs/gtk+-2.14:2=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfce4-panel-4.10:=
	upower? ( >=sys-power/upower-0.9.23 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	# For GEONAMES_USERNAME, read README file and ask ssuominen@!
	local myconf=(
		$(use_enable upower)
		GEONAMES_USERNAME=Gentoo
	)
	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

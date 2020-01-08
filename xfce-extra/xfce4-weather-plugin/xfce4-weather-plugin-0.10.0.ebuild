# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A weather plug-in for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-weather-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="upower"

RDEPEND=">=dev-libs/glib-2.42
	dev-libs/libxml2
	>=net-libs/libsoup-2.42[ssl]
	>=x11-libs/gtk+-3.22:3
	>=xfce-base/libxfce4ui-4.14:=
	>=xfce-base/libxfce4util-4.14:=
	>=xfce-base/xfce4-panel-4.14:=
	upower? ( >=sys-power/upower-0.9.23 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	# For GEONAMES_USERNAME, read README file and ask ssuominen@!
	local myconf=(
		$(use_enable upower)
		GEONAMES_USERNAME=Gentoo
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

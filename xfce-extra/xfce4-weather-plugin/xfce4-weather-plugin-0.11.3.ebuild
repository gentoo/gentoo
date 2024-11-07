# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A weather plug-in for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-weather-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="upower"

DEPEND="
	>=dev-libs/glib-2.64.0
	>=dev-libs/json-c-0.13.1:=
	dev-libs/libxml2
	>=net-libs/libsoup-2.42:2.4[ssl]
	>=x11-libs/gtk+-3.22.0
	>=xfce-base/libxfce4ui-4.14.0:=
	>=xfce-base/libxfce4util-4.14.0:=
	>=xfce-base/xfce4-panel-4.14.0:=
	>=xfce-base/xfconf-4.12.0:=
	upower? ( >=sys-power/upower-0.9.23 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

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
